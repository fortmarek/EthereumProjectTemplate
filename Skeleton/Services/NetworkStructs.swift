//
//  NetworkStructs.swift
//  Skeleton
//
//  Created by Jakub Olejník on 01/12/2017.
//

import Alamofire

typealias DataResponse = RequestResponse<Data>
typealias JSONResponse = RequestResponse<Any>

struct RequestAddress {
    var url: URL
}

struct RequestResponse<Value> {
    let statusCode: Int
    let headers: HTTPHeaders
    let data: Value?
}

enum RequestError: Error {
    case network(NetworkError)
    case upload(Error)
}

struct NetworkError: Error {
    let error: Error
    let request: URLRequest?
    let response: HTTPURLResponse?
    let data: Data?
    
    var statusCode: Int? { return response?.statusCode }
}

extension RequestResponse where Value == Data {
    func jsonResponse() throws -> JSONResponse {
        let json = try data.map { try JSONSerialization.jsonObject(with: $0, options: .allowFragments) }
        
        return JSONResponse(statusCode: statusCode, headers: headers, data: json)
    }
}


