//
//  Network.swift
//  Skeleton
//
//  Created by Jakub Olejník on 01/12/2017.
//

import Alamofire
import ReactiveSwift

protocol Networking {
    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<RequestResponse, NetworkError>
}

final class Network: Networking {
    
    private let sessionManager: SessionManager = {
        return SessionManager.default
    }()
    
    private let networkCallbackQueue = DispatchQueue.global(qos: .background)
    
    // MARK: Public methods
    
    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String : Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<RequestResponse, NetworkError> {
        
        return SignalProducer { [weak self] observer, lifetime in
            guard let `self` = self else { observer.sendInterrupted(); return }
            
            let dataRequest = self.sessionManager.request(address.url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .responseData(queue: self.networkCallbackQueue) { response in
                    if let error = response.error {
                        let networkError = NetworkError(error: error, request: response.request, response: response.response, data: response.data)
                        
                        observer.send(error: networkError)
                    } else if let httpResponse = response.response {
                        let headers = httpResponse.allHeaderFields as? HTTPHeaders ?? [:]
                        let requestResponse = RequestResponse(statusCode: httpResponse.statusCode, headers: headers, data: response.data)
                        
                        observer.send(value: requestResponse)
                        observer.sendCompleted()
                    } else {
                        observer.sendInterrupted()
                    }
            }
            
            lifetime.observeEnded {
                dataRequest.cancel()
            }
        }
    }
}
