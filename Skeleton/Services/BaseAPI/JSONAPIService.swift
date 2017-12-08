//
//  JSONAPIService.swift
//  Skeleton
//
//  Created by Jakub Olejník on 01/12/2017.
//

import ReactiveSwift

import enum Alamofire.HTTPMethod
import protocol Alamofire.ParameterEncoding
import struct Alamofire.URLEncoding
import struct Alamofire.JSONEncoding
import struct Alamofire.HTTPHeaders
import enum Result.Result

typealias HTTPMethod = Alamofire.HTTPMethod
typealias ParameterEncoding = Alamofire.ParameterEncoding
typealias HTTPHeaders = Alamofire.HTTPHeaders
typealias URLEncoding = Alamofire.URLEncoding
typealias JSONEncoding = Alamofire.JSONEncoding

final class JSONAPIService {
    
    private let network: Networking
    
    // MARK: Initializers
    
    init(network: Networking) {
        self.network = network
    }
    
    // MARK: Public methods
    
    func request(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [String: Any] = [:], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        return network.request(address, method: method, parameters: parameters, encoding: encoding, headers: headers).toJSON()
    }
    
    func upload(_ address: RequestAddress, method: HTTPMethod = .get, parameters: [NetworkUploadable], headers: HTTPHeaders = [:]) -> SignalProducer<JSONResponse, RequestError> {
        return network.upload(address, method: method, parameters: parameters, headers: headers).toJSON()
    }
}

extension SignalProducer where Value == DataResponse, Error == RequestError {
    func toJSON() -> SignalProducer<JSONResponse, Error> {
        return attemptMap { dataResponse in
            do {
                let jsonResponse = try dataResponse.jsonResponse()
                return Result.success(jsonResponse)
            }
            catch {
                return Result.failure(.network(NetworkError(error: error, request: nil, response: nil, data: dataResponse.data)))
            }
        }
    }
}
