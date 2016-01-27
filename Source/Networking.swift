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

protocol Networking{
    func call<T>(route: APIRouter, authHandler: AuthHandler?, useDisposables : Bool, action: (AnyObject -> (SignalProducer<T,NSError>))) -> SignalProducer<T,NSError>
}