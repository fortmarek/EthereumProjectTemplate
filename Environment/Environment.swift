//
//  Environment.swift
//  ProjectSkeleton
//
//  Created by Petr Šíma on Jun/24/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

enum Environment {
	private static let plist : [String: AnyObject] = NSDictionary(contentsOfFile:(NSBundle.mainBundle().pathForResource("environment", ofType:"plist")!))! as! [String : AnyObject]
	
	enum Scheme : String {
		case AppStore = "AppStore"
		case AdHoc = "AdHoc"
		case Development = "Development"
		case Undefined = "Undefined"
		var description : String { return rawValue }
	}
//	static var scheme : Scheme { return Scheme(rawValue: (plist["scheme"] as? String) ?? "") ?? .Undefined } //this no longer works, someone removed it from the script
	static var appName : String { return plist["appName"]! as! String }
    
    enum Api {
        private static let apiDict = plist["api"] as! [String : AnyObject]
        
        static var baseURL : String { return apiDict["baseURL"] as! String }
    }
	
    enum Hockey {
        
        static var identifier : String { return plist["hockey_identifier"] as! String }
        static var allowLogging : Bool { return plist["hockey_allowLogging"] as? Bool ?? true }
    }
}