//
//  APIService.swift
//  Rekola
//
//  Created by Dominik Vesely on 10/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa

let API = ProjectNameAPI._instance //convenience access to api singleton

struct APIErrorKeys {
	static let response = "FailingRequestResponse"
	static let responseData = "FailingRequestResponseData"
}

class ProjectNameAPI {

	static let _instance = ProjectNameAPI()
	private init() {}
	
	enum Router : URLRequestConvertible {
		
		static let baseURL = Environment.Api.baseURL
		case Login(dictionary: [String:AnyObject])
		
		var method : Alamofire.Method {
			switch self {
			case .Login:
				return .POST
			}
		}
		
		var path : String {
			switch self {
			case .Login:
				return "/accounts/mine/login"
			}
		}
		
		var URLRequest : NSMutableURLRequest {
			let URL = NSURL(string: Router.baseURL)!
			let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
			mutableURLRequest.HTTPMethod = method.rawValue
            
            // default version header should be always sent
            if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
                mutableURLRequest.setValue(version, forHTTPHeaderField: "X-Version")
            }
            
			if let key = NSUserDefaults.standardUserDefaults().stringForKey("apiKey") {
				mutableURLRequest.setValue(key, forHTTPHeaderField: "X-Api-Key")
			}
			switch self {
			case .Login(let params):
				return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: params).0
			default:
				return mutableURLRequest
			}
		}
	}
	typealias AuthHandler = (error: NSError) -> SignalProducer<AnyObject, NSError>?
	
	private static func authHandler(error: NSError) -> SignalProducer<AnyObject, NSError>? { //instance method cant be used as default parameter of call, this solution is ok as long as RekolaAPI is a singleton
		if let response = error.userInfo[APIErrorKeys.response] as? NSHTTPURLResponse {
			switch response.statusCode {
				case 401:
					return _instance.login("putCurrentUsernameHere", password: "putCurrentPasswordHere").flatMap(.Merge) { _ in SignalProducer.empty } //login doesnt have to send any values. If it sends a value, the value is ignored, the signal completes and is unsubscribed from
				default:
					return nil
			}
		}
		return nil
	}
	
    private func call<T>(route: Router, let authHandler: AuthHandler? = ProjectNameAPI.authHandler, useDisposables : Bool = true, action: (AnyObject -> (SignalProducer<T,NSError>))) -> SignalProducer<T,NSError> {
        let signal = SignalProducer<T,NSError> { sink, disposable in
            
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
                        do{
                            let jsonString = try NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)
                            let str =  action(jsonString)
                            let actionDisposable = str.start(sink)
                            
                            if useDisposables {
                                disposable.addDisposable(actionDisposable) // if disposed dispose running action
                            }
                        }catch {
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
                }else{
                    return SignalProducer(error: error)
                }
            }
        }else{
            return signal
        }
    }

    func login(username: String, password: String) -> SignalProducer<String,NSError>  {
        return  call(.Login(dictionary:["password" : password, "username" : username])) { data in
            //namapuju resp zgrootuju
				return SignalProducer.empty
        }
    }
	
}







