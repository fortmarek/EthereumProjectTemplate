//
//  Network.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa

class Network: Networking {

    func request(url: String, method: Alamofire.Method = .GET, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<AnyObject, NetworkError> {
        return SignalProducer { sink, disposable in
            let request = Alamofire.request(method, url,
                parameters: parameters,
                headers: headers,
                encoding: encoding)
                .validate()
                .response() { (request, response, data, error) in

                    switch (data, error) {
                    case (_, .Some(let e)):
                        sink.sendFailed(NetworkError(error: e, request: request, response: response))
                    case (.Some(let d), _):
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(d, options: .AllowFragments)
                            sink.sendNext(json)
                            sink.sendCompleted()
                        } catch {
                            sink.sendFailed(NetworkError(error: (error as NSError), request: request, response: response))
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
    }
}
