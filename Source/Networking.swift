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


typealias AuthHandler = (error: NSError) -> SignalProducer<AnyObject, NSError>?

protocol Networking {
    func request(url: String, method: Alamofire.Method, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?, authHandler: AuthHandler?, useDisposables: Bool) -> SignalProducer<AnyObject, NSError>
}
