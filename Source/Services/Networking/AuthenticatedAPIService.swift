//
//  AuthenticatedAPIService.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 22/08/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift

// Provides authorization for AuthenticatedAPIService (e.g: UserManager)
protocol AuthorizationProvider {
    var authorizationHeaders: [String: String] {get}
}

// Handles refresh and its failure when authorization fails
protocol AuthHandling {
    var refreshAction: Action<NetworkError, (), UserError> { get }
}

class AuthenticatedAPIService: APIService {
    let authorizationProvider: AuthorizationProvider
    private let authHandler: AuthHandling
    
    required init(network: Networking, authHandler: AuthHandling, authorizationProvider: AuthorizationProvider) {
        self.authorizationProvider = authorizationProvider
        self.authHandler = authHandler
        super.init(network: network)
    }
    
    func addAuthorization(toHeaders headers: [String: String]) -> [String: String] {
        var headers = headers
        self.authorizationProvider.authorizationHeaders.forEach { headers.updateValue($1, forKey: $0) }
        return headers
    }
    
    override func request(_ address: RequestAddress, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:]) -> SignalProducer<RequestResult, RequestError> {
        let allHeaders = addAuthorization(toHeaders: headers)
        
        return super.request(address, method: method, parameters: parameters, encoding: encoding, headers: allHeaders)
            .flatMapError { [unowned self] e in self.unauthorizedHandler(e: e, address: address, method: method, parameters: parameters, encoding: encoding, headers: headers) }
    }
    
    private func unauthorizedHandler(e: RequestError, address: RequestAddress, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]) -> SignalProducer<RequestResult, RequestError> {
        guard case .network(let networkError) = e, networkError.response?.statusCode == 401,
            let originalRequest = networkError.request
            else { return SignalProducer(error: e) }
        
        let retry = { [unowned self] in
            self.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers)
        }
        
        guard self.requestUsedCurrentAuthData(request: originalRequest as NSURLRequest) else { return retry() } // check that we havent refreshed token while the request was running
        
        let refreshSuccessful = SignalProducer(authHandler.refreshAction.events)
            .filter { $0.isTerminating } // dont care about values
            .map { e -> Bool in
                switch e {
                case .completed: return true
                case .failed, .interrupted: return false
                default: assertionFailure(); return false
                }
            }
            .take(first: 1)
        
        return refreshSuccessful
            .on(started: {
                DispatchQueue.main.async { // fire the authHandler in next runloop to prevent recursive events in case that authHandler completes synchronously
                    self.authHandler.refreshAction.apply(networkError).start() // sideeffect
                }
            })
            .promoteError(RequestError.self)
            .flatMap(.latest) { success -> SignalProducer<RequestResult, RequestError> in
                guard success else { return SignalProducer(error: .network(networkError)) }
                return retry()
        }
    }
    
    func requestUsedCurrentAuthData(request: NSURLRequest) -> Bool {
        guard let allHeaders = request.allHTTPHeaderFields else { return true }
        return allHeaders == addAuthorization(toHeaders: allHeaders)
    }
}
