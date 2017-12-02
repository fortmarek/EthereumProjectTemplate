//
//  AuthenticatedJSONAPIService.swift
//  Skeleton
//
//  Created by Jakub Olejník on 02/12/2017.
//

import ACKategories
import ReactiveSwift

final class AuthenticatedJSONAPIService {
    
    private let jsonAPI: JSONAPIService
    private let authHandler: AuthHandling
    private let credentialsProvider: CredentialsProvider
    
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
    }
    
    func upload(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        let jsonAPI = self.jsonAPI
        return authorizationHeadersProducer()
            .flatMap(.latest) { jsonAPI.upload(address, method: method, parameters: parameters, headers: headers + $0) }
    }
    
    // MARK: Private helpers
    
    private func authorizationHeadersProducer() -> SignalProducer<HTTPHeaders, RequestError> {
        let credentialsProvider = self.credentialsProvider
        return SignalProducer { observer, _ in
            let headers = credentialsProvider.credentials.map { ["Authorization": "Bearer " + $0.accessToken] } ?? [:]
            
            observer.send(value: headers)
            observer.sendCompleted()
        }
    }
}
