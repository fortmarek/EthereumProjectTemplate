//
//  HockeySDKAppDelegate.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 07/04/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation
import HockeySDK

public class HockeySDKAppDelegate: NSObject, UIApplicationDelegate, BITHockeyManagerDelegate {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Start Hockey Manager
        if Environment.Hockey.identifier.characters.count != 0 && Environment.Hockey.allowLogging {
            let hockeyManager = BITHockeyManager.shared()
            hockeyManager.configure(withIdentifier: Environment.Hockey.identifier, delegate: self)
            hockeyManager.start()
            hockeyManager.authenticator.authenticateInstallation()
            hockeyManager.crashManager.crashManagerStatus = .autoSend
        }
        
        return true
    }
    
}
