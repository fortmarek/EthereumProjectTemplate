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
import Argo

typealias AuthHandler = Action<NetworkError, (), NSError>

//Base class which all API Services should inherit

enum RequestError: Error {
    case network(NetworkError)
    case mapping(DecodeError)
}
extension RequestError: ErrorPresentable {
    var message: String {
        switch self {
        case .network(let e): return e.error.message
        case .mapping(_): return L10n.genericMappingError.string
        }
    }
}

class APIService {
    // MARK: Dependencies
    fileprivate let network: Networking
    fileprivate let authHandler: AuthHandler?

    init(network: Networking, authHandler: AuthHandler?) {
        self.network = network
        self.authHandler = authHandler
    }

    func resourceURL(_ path: String) -> URL {
        let URL = Foundation.URL(string: Environment.Api.baseURL)!
        let relativeURL = Foundation.URL(string: path, relativeTo: URL)!
        return relativeURL
    }

    func request(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:], authHandler: AuthHandler? = nil) -> SignalProducer<Any, NetworkError> {
        let relativeURL = resourceURL(path)
        return self.network.request(relativeURL.absoluteString, method: method, parameters: parameters, encoding: encoding, headers: headers, useDisposables: false)
            .flatMapError { [unowned self] networkError in
                guard networkError.response?.statusCode == 401,
                    let authHandler = authHandler,
                    let originalRequest = networkError.request
                else { return SignalProducer(error: networkError) }

                let retry = { [unowned self] in
                    self.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers, authHandler: authHandler)
                }

                guard self.requestUsedCurrentAuthData(originalRequest) else { return retry() } // check that we havent refreshed token while the request was running

                let refreshSuccessful = SignalProducer(signal: authHandler.events)
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
                            authHandler.apply(networkError).start() // sideeffect
                        }
                })
                    .promoteErrors(NetworkError.self)
                    .flatMap(.latest) { success -> SignalProducer<Any, NetworkError> in
                        guard success else { return SignalProducer(error: networkError) }
                        return retry()
                }
        }
    }

    func requestUsedCurrentAuthData(_ request: URLRequest) -> Bool {
        return true
    }
}

class AuthenticatedAPIService: APIService {
    let userManager: UserManaging

    required init(network: Networking, authHandler: AuthHandler?, userManager: UserManaging) {
        self.userManager = userManager
        super.init(network: network, authHandler: authHandler)
    }

    func authorizationHeaders(_ headers: [String: String]) -> [String: String] {
        var authHeaders = headers
        if let credentials = self.userManager.credentials {
            authHeaders["Authorization"] = "\(credentials.token_type.capitalized) \(credentials.access_token)"
        }
        return authHeaders
    }

    override func request(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any]? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String: String] = [:], authHandler: AuthHandler? = nil) -> SignalProducer<Any, NetworkError> {
        let allHeaders = authorizationHeaders(headers)

        return super.request(path, method: method, parameters: parameters, encoding: encoding, headers: allHeaders, authHandler: (authHandler == nil) ? self.authHandler : authHandler)
    }

    override func requestUsedCurrentAuthData(_ request: URLRequest) -> Bool {
        guard let allHeaders = request.allHTTPHeaderFields else { return true }
        return allHeaders == authorizationHeaders(allHeaders)
    }
}
