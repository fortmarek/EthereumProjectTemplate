//
//  NetworkStructs.swift
//  Skeleton
//
//  Created by Jakub Olejník on 01/12/2017.
//

import Alamofire

struct RequestAddress {
    var url: URL
}

struct RequestResponse {
    let statusCode: Int
    let headers: HTTPHeaders
    let data: Data?
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
