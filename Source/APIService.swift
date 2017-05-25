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

// Base class which all API Services should inherit

struct RequestAddress {
    let base: String
    let path: String
    
    var url: URL {
        let baseURL = URL(string: base)!
        return URL(string: path, relativeTo: baseURL)!
    }
    
    var urlString: String { return url.absoluteString }
}
extension RequestAddress {
    init(path: String) {
        self.base = Environment.Api.baseURL
        self.path = path
    }
}

enum RequestError: Error {
    case network(NetworkError)
    case mapping(MappingError)
    case unexpectedEmptyBody
}
extension RequestError: ErrorPresentable {
    var message: String {
        switch self {
        case .network(let e): return e.error.message
        case .mapping, .unexpectedEmptyBody: return L10n.Basic.genericMappingError
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
    
    func request(_ address: RequestAddress, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:]) -> SignalProducer<RequestResult, RequestError> {
        let headers = addCustomHeaders(toHeaders: headers)
        
        return self.network.request(address.urlString, method: method, parameters: parameters, encoding: encoding, headers: headers, useDisposables: false).mapError { .network($0) }
    }
    
    func addCustomHeaders(toHeaders headers: [String: String]) -> [String: String] {
        let customHeaders = headers
        
        //customHeaders["X-DeviceId"] = UserDefaults.standard.deviceId
        //customHeaders["X-Api-Key"] = Environment.Api.apiKey
        
        return customHeaders
    }
}

extension APIService {
    func request(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:]) -> SignalProducer<RequestResult, RequestError> {
        return request(RequestAddress(path: path), method: method, parameters: parameters, encoding: encoding, headers: headers)
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
            .promoteErrors(RequestError.self)
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

extension SignalProducerProtocol where Value == RequestResult, Error == RequestError {
    
    /**
     * Call this if you expect your request to return non empty body.
     * If request returns empty body and it is unexpected (this method is called) RequestError.unexpectedEmptyBody is sent
     */
    func validateEmptyValue() -> SignalProducer<Any, RequestError> {
        return flatMap(.latest) { requestResult -> SignalProducer<Any, RequestError> in
            switch requestResult {
            case .data(let data):
                return SignalProducer(value: data)
            case .noContent:
                return SignalProducer(error: .unexpectedEmptyBody)
            }
        }
    }
}
