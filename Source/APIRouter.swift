//
//  APIRouter.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/27/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Alamofire

protocol APIRouter : URLRequestConvertible {
    func requestForURL(url: NSURL, method:Alamofire.Method)->NSMutableURLRequest
}

extension APIRouter{
    func requestForURL(url: NSURL, method:Alamofire.Method)->NSMutableURLRequest {
        let mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        // default version header should be always sent
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            mutableURLRequest.setValue(version, forHTTPHeaderField: "X-Version")
        }
        
        if let key = NSUserDefaults.standardUserDefaults().stringForKey("apiKey") {
            mutableURLRequest.setValue(key, forHTTPHeaderField: "X-Api-Key")
        }
        
        return mutableURLRequest
    }
}