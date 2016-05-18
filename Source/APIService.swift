//
//  APIService.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import Argo

typealias AuthHandler = Action<NetworkError, (), NSError>

//Base class which all API Services should inherit

enum RequestError: ErrorType {
    case Network(NetworkError)
    case Mapping(DecodeError)
}
extension RequestError: ErrorPresentable {
    var message: String {
        switch self {
        case .Network(let e): return e.error.message
        case .Mapping(_): return L10n.GenericMappingError.string
        }
    }
}

class APIService {
    // MARK: Dependencies
    private let network: Networking
    private let authHandler: AuthHandler?

    init(network: Networking, authHandler: AuthHandler?) {
        self.network = network
        self.authHandler = authHandler
    }

    func resourceURL(path: String) -> NSURL {
        let URL = NSURL(string: Environment.Api.baseURL)!
        let relativeURL = NSURL(string: path, relativeToURL: URL)!
        return relativeURL
    }

    func request(path: String, method: Alamofire.Method = .GET, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String] = [:], authHandler: AuthHandler? = nil) -> SignalProducer<AnyObject, NetworkError> {
        let relativeURL = resourceURL(path)
        return self.network.request(relativeURL.URLString, method: method, parameters: parameters, encoding: encoding, headers: headers, useDisposables: false)
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
                    case .Completed: return true
                    case .Failed, .Interrupted: return false
                    default: assertionFailure(); return false
                    }
                }
                    .take(1)

                authHandler.apply(networkError).start() // sideeffect

                return refreshSuccessful
                    .promoteErrors(NetworkError)
                    .flatMap(.Latest) { success -> SignalProducer<AnyObject, NetworkError> in
                        guard success else { return SignalProducer(error: networkError) }
                        return retry()
                }
        }
    }

    func requestUsedCurrentAuthData(request: NSURLRequest) -> Bool {
        return true
    }
}

class AuthenticatedAPIService: APIService {
    let userManager: UserManaging

    required init(network: Networking, authHandler: AuthHandler?, userManager: UserManaging) {
        self.userManager = userManager
        super.init(network: network, authHandler: authHandler)
    }

    func authorizationHeaders(headers: [String: String]) -> [String: String] {
        var authHeaders = headers
        if let credentials = self.userManager.credentials {
            authHeaders["Authorization"] = "\(credentials.token_type.capitalizedString) \(credentials.access_token)"
        }
        return authHeaders
    }

    override func request(path: String, method: Alamofire.Method = .GET, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String] = [:], authHandler: AuthHandler? = nil) -> SignalProducer<AnyObject, NetworkError> {
        let allHeaders = authorizationHeaders(headers)

        return super.request(path, method: method, parameters: parameters, encoding: encoding, headers: allHeaders, authHandler: /*(authHandler == nil) ? self.authHandler : authHandler*/            nil)
    }

    override func requestUsedCurrentAuthData(request: NSURLRequest) -> Bool {
        guard let allHeaders = request.allHTTPHeaderFields else { return true }
        return allHeaders == authorizationHeaders(allHeaders)
    }
}
