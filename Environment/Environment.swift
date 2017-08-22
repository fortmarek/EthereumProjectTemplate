//
//  Environment.swift
//  ProjectSkeleton
//
//  Created by Petr Šíma on Jun/24/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

private class BundleToken {}

public enum Environment {
    fileprivate static let plist : [String: AnyObject] = NSDictionary(contentsOfFile:(Bundle(for: BundleToken.self).path(forResource: "environment", ofType:"plist")!))! as! [String : AnyObject]
	
    enum Api {
        fileprivate static let apiDict = plist["api"] as! [String : AnyObject]
        
        static var baseURL : String { return apiDict["baseURL"] as! String }
    }
	
    public enum Hockey {
        public static var identifier : String { return plist["hockey_identifier"] as! String }
        public static var allowLogging : Bool { return plist["hockey_allowLogging"] as? Bool ?? true }
    }
}
