//
//  APIService.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift


//Base class which all API Services should inherit

enum RequestError: Error {
    case network(NetworkError)
    case mapping(MappingError)
}
extension RequestError: ErrorPresentable {
    var message: String {
        switch self {
        case .network(let e): return e.error.message
        case .mapping(_): return L10n.genericMappingError.string
        }
    }
}

struct MappingError: ErrorWrapping {
    let underlyingError: Error
}


class APIService {
    // MARK: Dependencies
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func resourceURL(_ path: String) -> URL {
        //TODO: get rid of this coeffect, pass baseURL to initializer
        let URL = Foundation.URL(string: Environment.Api.baseURL)!
        let relativeURL = Foundation.URL(string: path, relativeTo: URL)!
        return relativeURL
    }
    
    func request(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:]) -> SignalProducer<Any, RequestError> {
        let relativeURL = resourceURL(path)
        let headers = addCustomHeaders(toHeaders: headers)
        
        return self.network.request(relativeURL.absoluteString, method: method, parameters: parameters, encoding: encoding, headers: headers, useDisposables: false).mapError { .network($0) }
    }

    func addCustomHeaders(toHeaders headers: [String: String]) -> [String: String] {
        var customHeaders = headers
        
        //customHeaders["X-DeviceId"] = UserDefaults.standard.deviceId
        //customHeaders["X-Api-Key"] = Environment.Api.apiKey
        
        return customHeaders
    }
}


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
    
    override func request(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:]) -> SignalProducer<Any, RequestError> {
        let allHeaders = addAuthorization(toHeaders: headers)
        
        return super.request(path, method: method, parameters: parameters, encoding: encoding, headers: allHeaders)
            .flatMapError { [unowned self] e in self.unauthorizedHandler(e: e, path: path, method: method, parameters: parameters, encoding: encoding, headers: headers) }
    }
    
    private func unauthorizedHandler(e: RequestError, path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String]) -> SignalProducer<Any, RequestError> {
        guard case .network(let networkError) = e, networkError.response?.statusCode == 401,
            let originalRequest = networkError.request
            else { return SignalProducer(error: e) }
        
        let retry = { [unowned self] in
            self.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers)
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
            .promoteErrors(RequestError.self)
            .flatMap(.latest) { success -> SignalProducer<Any, RequestError> in
                guard success else { return SignalProducer(error: .network(networkError)) }
                return retry()
        }
    }
    
    
    func requestUsedCurrentAuthData(request: NSURLRequest) -> Bool {
        guard let allHeaders = request.allHTTPHeaderFields else { return true }
        return allHeaders == addAuthorization(toHeaders: allHeaders)
    }
}
