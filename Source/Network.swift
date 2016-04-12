//
//  Network.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa

class Network: Networking {


    func call(route: APIRouter, authHandler: AuthHandler?, useDisposables: Bool = true) -> SignalProducer<AnyObject, NSError> {
        let requestProducer = SignalProducer<AnyObject, NSError> { sink, disposable in

            let request = Alamofire.request(route)

            request.validate()
                .response { (request, response, data, error) in
                    switch (data, error) {
                    case (_, .Some(let e)):
                        //TODO: refactor this shitcode for swift2
                        let newInfo = NSMutableDictionary(object: response ?? NSNull(), forKey: APIErrorKeys.response)
                        newInfo.addEntriesFromDictionary([APIErrorKeys.responseData : data ?? NSNull()])
                        let userInfo = e.userInfo
                        newInfo.addEntriesFromDictionary(userInfo)
                        let newInfoImmutable = newInfo.copy() as! NSDictionary
                        let newError = NSError(domain: e.domain, code: e.code, userInfo: newInfoImmutable as [NSObject : AnyObject])
                        sink.sendFailed(newError)
                    case (.Some(let d), _):
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments)
                            sink.sendNext(json)
                            sink.sendCompleted()
                        } catch {
                            sink.sendFailed(error as! NSError)
                            return
                        }
                    default: assertionFailure()
                    }
            }

            if useDisposables {
                disposable.addDisposable { // if disposed cancel running request
                    request.cancel()
                }
            }
        }

        if let handler = authHandler {
            return requestProducer.flatMapError { error in
                if let handlingCall = handler(error: error) {
                    return handlingCall.then(requestProducer)
                } else {
                    return SignalProducer(error: error)
                }
            }
        } else {
            return requestProducer
        }
    }
}
