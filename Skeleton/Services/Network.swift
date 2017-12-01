//
//  Network.swift
//  Skeleton
//
//  Created by Jakub Olejník on 01/12/2017.
//

import Alamofire
import ReactiveSwift

protocol Networking {
    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<RequestResponse, RequestError>
    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<RequestResponse, RequestError>
}

final class Network: Networking {
    
    private let sessionManager: SessionManager = {
        return SessionManager.default
    }()
    
    fileprivate static let networkCallbackQueue = DispatchQueue.global(qos: .background)
    
    // MARK: Public methods
    
    func request(_ address: RequestAddress, method: HTTPMethod, parameters: [String : Any], encoding: ParameterEncoding, headers: HTTPHeaders) -> SignalProducer<RequestResponse, RequestError> {
        return SignalProducer { [weak self] observer, lifetime in
            guard let `self` = self else { observer.sendInterrupted(); return }
            
            let task = self.sessionManager.request(address.url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .handleResponse(observer: observer)
            
            lifetime.observeEnded {
                task.cancel()
            }
        }
    }
    
    func upload(_ address: RequestAddress, method: HTTPMethod, parameters: [NetworkUploadable], headers: HTTPHeaders) -> SignalProducer<RequestResponse, RequestError> {
        return SignalProducer { [weak self] observer, lifetime in
            guard let `self` = self else { observer.sendInterrupted(); return }
            
            self.sessionManager.upload(
                multipartFormData: { multipart in parameters.forEach { $0.append(multipart: multipart) } },
                usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
                to: address.url,
                method: method,
                headers: headers) { encodingResult in
                    switch encodingResult {
                    case .success(let uploadRequest, _, _):
                        uploadRequest
                            .validate()
                            .handleResponse(observer: observer)
                        
                    case .failure(let error):
                        observer.send(error: .upload(error))
                    }
            }
        }
    }
}

private extension DataRequest  {
    @discardableResult
    func handleResponse(observer: Signal<RequestResponse, RequestError>.Observer) -> Self {
        return responseData(queue: Network.networkCallbackQueue) { response in
            if let error = response.error {
                let networkError = NetworkError(error: error, request: response.request, response: response.response, data: response.data)
                
                observer.send(error: .network(networkError))
            } else if let httpResponse = response.response {
                let headers = httpResponse.allHeaderFields as? HTTPHeaders ?? [:]
                let requestResponse = RequestResponse(statusCode: httpResponse.statusCode, headers: headers, data: response.data)
                
                observer.send(value: requestResponse)
                observer.sendCompleted()
            } else {
                observer.sendInterrupted()
            }
        }
    }
}
