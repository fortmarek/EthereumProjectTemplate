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
