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



    func call<T>(route: APIRouter, authHandler: AuthHandler?, useDisposables: Bool = true, action: (AnyObject -> (SignalProducer<T, NSError>))) -> SignalProducer<T, NSError> {
        let signal = SignalProducer<T, NSError> { sink, disposable in

            let request = Alamofire.request(route)

            request.validate()
                .response { (request, response, data, error) in
                    if let error = error {
                        //TODO: refactor this shitcode for swift2
                        let newInfo = NSMutableDictionary(object: response ?? NSNull(), forKey: APIErrorKeys.response)
                        newInfo.addEntriesFromDictionary([APIErrorKeys.responseData : data ?? NSNull()])
                        let userInfo = (error as NSError).userInfo
                        newInfo.addEntriesFromDictionary(userInfo)
                        let newInfoImmutable = newInfo.copy() as! NSDictionary
                        let newError = NSError(domain: (error as NSError).domain, code: (error as NSError).code, userInfo: newInfoImmutable as [NSObject : AnyObject])
                        sink.sendFailed(newError)
                        return
                    }
                    if let json = data {
                        do {
                            let jsonString = try NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)

                            print(jsonString)
                            let str =  action(jsonString)
                            let actionDisposable = str.start(sink)

                            if useDisposables {
                                disposable.addDisposable(actionDisposable) // if disposed dispose running action
                            }
                        } catch {
                            sink.sendFailed(error as! NSError)
                            return
                        }
                        return
                    }
                    sink.sendFailed(NSError(domain: "", code: 0, userInfo: nil))//shouldnt get here
            }

            if useDisposables {
                disposable.addDisposable { // if disposed cancel running request
                    request.cancel()
                }
            }

            return
        }

        if let handler = authHandler {
            return signal.flatMapError { error in
                if let handlingCall = handler(error: error) {
                    return handlingCall.then(signal)
                } else {
                    return SignalProducer(error: error)
                }
            }
        } else {
            return signal
        }
    }
}
