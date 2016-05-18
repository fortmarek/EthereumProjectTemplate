//
//  Networking.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa

struct NetworkError: ErrorType {
    let error: NSError
    let request: NSURLRequest?
    let response: NSHTTPURLResponse?
}

protocol Networking {
    func request(url: String, method: Alamofire.Method, parameters: [String: AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<AnyObject, NetworkError>
}
