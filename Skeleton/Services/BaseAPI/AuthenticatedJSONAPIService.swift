//
//  AuthenticatedJSONAPIService.swift
//  Skeleton
//
//  Created by Jakub Olejník on 02/12/2017.
//

import ACKategories
import ReactiveSwift

final class AuthenticatedJSONAPIService: UnauthorizedHandling {
    
    private let jsonAPI: JSONAPIService
    private let authHandler: AuthHandling
    private let credentialsProvider: CredentialsProvider
    
    private var authorizationHeaders: HTTPHeaders { return credentialsProvider.credentials.map { ["Authorization": "Bearer " + $0.accessToken] } ?? [:] }
    
    // MARK: Initializers
    
    init(jsonAPI: JSONAPIService, authHandler: AuthHandling, credentialsProvider: CredentialsProvider) {
        self.jsonAPI = jsonAPI
        self.authHandler = authHandler
        self.credentialsProvider = credentialsProvider
    }
    
    // MARK: Public methods
    
    func request(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [String: Any] = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        let jsonAPI = self.jsonAPI
        
        return authorizationHeadersProducer()
            .flatMap(.latest) { jsonAPI.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers + $0) }
            .flatMapError { [unowned self] in
                self.unauthorizedHandler(error: $0, authHandler: self.authHandler, authorizationHeaders: self.authorizationHeaders) { [unowned self] in
                    self.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers)
                }
        }
    }
    
    func upload(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        let jsonAPI = self.jsonAPI
        
        return authorizationHeadersProducer()
            .flatMap(.latest) { jsonAPI.upload(address, method: method, parameters: parameters, headers: headers + $0) }
            .flatMapError { [unowned self] in
                self.unauthorizedHandler(error: $0, authHandler: self.authHandler, authorizationHeaders: self.authorizationHeaders) { [unowned self] in
                    self.upload(address, method: method, parameters: parameters, headers: headers)
                }
        }
    }
    
    // MARK: Private helpers
    
    private func authorizationHeadersProducer() -> SignalProducer<HTTPHeaders, RequestError> {
        return SignalProducer { [weak self] observer, _ in
            guard let `self` = self else { observer.sendInterrupted(); return }
            observer.send(value: self.authorizationHeaders)
            observer.sendCompleted()
        }
    }
}
