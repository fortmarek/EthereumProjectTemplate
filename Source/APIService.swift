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

//Base class which all API Services should inherit

struct APIErrorKeys {
    static let response = "FailingRequestResponse"
    static let responseData = "FailingRequestResponseData"
}

enum RequestError: ErrorType {
    case Network(NSError)
    case Mapping(DecodeError)
}
extension RequestError : ErrorPresentable {
    var message: String {
        switch self {
        case .Network(let e): return e.message
        case .Mapping(_): return L10n.GenericMappingError.string
        }
    }
}


class APIService {
    //MARK: Dependencies
    private let network: Networking
    
    required init(network: Networking) {
        self.network = network
    }
    
    func resourceURL(path: String) -> NSURL {
        let URL = NSURL(string: Environment.Api.baseURL)!
        let relativeURL = NSURL(string: path, relativeToURL:URL)!
        return relativeURL
    }
    
    func request(path: String, method: Alamofire.Method = .GET, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String] = [:], authHandler: AuthHandler? = nil)  -> SignalProducer<AnyObject, NSError> {
        let relativeURL = resourceURL(path)
        return self.network.request(relativeURL.URLString, method: method, parameters: parameters, encoding: encoding, headers: headers, authHandler: authHandler, useDisposables: false)
    }
}

class AuthenticatedAPIService: APIService {
    let userManager: UserManaging
    
    required init(network: Networking, userManager: UserManaging) {
        self.userManager = userManager
        super.init(network: network)
    }
    
    required init(network: Networking) {
        fatalError("init(network:) has not been implemented")
    }
    
    
    typealias AuthHandler = (error: NSError) -> SignalProducer<AnyObject, NSError>?
    
    private func authHandler(error: NSError) -> SignalProducer<AnyObject, NSError>? { //instance method cant be used as default parameter of call, this solution is ok as long as RekolaAPI is a singleton
        if let response = error.userInfo[APIErrorKeys.response] as? NSHTTPURLResponse {
            switch response.statusCode {
            case 401:
                
                
                //self.userManager.refresh
                
                return nil
                //return _instance.login("putCurrentUsernameHere", password: "putCurrentPasswordHere").flatMap(.Merge) { _ in SignalProducer.empty } //login doesnt have to send any values. If it sends a value, the value is ignored, the signal completes and is unsubscribed from
            default:
                return nil
            }
        }
        return nil
    }
    
    func authorizationHeaders(headers: [String: String]) -> [String:String] {
        var authHeaders = headers
        if let credentials = self.userManager.credentials {
            authHeaders["Authorization"] = "\(credentials.token_type.capitalizedString) \(credentials.access_token)"
        }
        return authHeaders
    }
    
    override func request(path: String, method: Alamofire.Method = .GET, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, var headers: [String: String] = [:], authHandler: AuthHandler? = nil) -> SignalProducer<AnyObject, NSError> {
        headers = authorizationHeaders(headers)
        
        return super.request(path, method: method, parameters: parameters, encoding: encoding, headers: headers, authHandler: (authHandler == nil) ? self.authHandler : authHandler)
    }
}
