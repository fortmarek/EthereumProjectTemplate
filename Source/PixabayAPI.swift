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

struct APIErrorKeys {
	static let response = "FailingRequestResponse"
	static let responseData = "FailingRequestResponseData"
}

class PixabayAPI: API {
    
    //MARK: Dependencies
    private let network:Networking
    
    
    required init(network:Networking) {
        self.network = network
    }
	
	enum Router : APIRouter {
		
        //What with this?
		static let baseURL = Pixabay.apiURL
        
        
        case Images(page:Int)
		
		var method : Alamofire.Method {
			switch self {
			case .Images(_):
				return .GET
			}
		}
		
		var path : String {
			switch self {
			case .Images(let page):
                return "?key=\(Pixabay.Config.apiKey)&image_type=photo&safesearch=1&per_page=50&page=\(page)"
			}
		}
		
		var URLRequest : NSMutableURLRequest {
            
            let URL = NSURL(string: Router.baseURL)!
            let mutableURLRequest = self.requestForURL(NSURL(string: path, relativeToURL:URL)!, method: method)
            
            
			switch self {
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
                    return nil
					//return _instance.login("putCurrentUsernameHere", password: "putCurrentPasswordHere").flatMap(.Merge) { _ in SignalProducer.empty } //login doesnt have to send any values. If it sends a value, the value is ignored, the signal completes and is unsubscribed from
				default:
					return nil
			}
		}
		return nil
	}
	
    

    func loadImages(page: Int) -> SignalProducer<[ImageEntity],NSError>  {
        return self.network.call(Router.Images(page: page), authHandler:nil, useDisposables: false) { data in
            return rac_decodeWithRootKey("hits", object: data)
        }
    }
	
}







