//
//  Networking.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift

struct NetworkError: Error {
    let error: NSError
    let request: URLRequest?
    let response: HTTPURLResponse?
}

protocol Networking {
    func request(_ url: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<Any, NetworkError>
}
