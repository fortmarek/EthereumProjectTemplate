//
//  MainAppDelegate.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 07/04/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation
import UIKit

public class MainAppDelegate: NSObject, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let assembler = AppAssembler
        
        
        // Resolve initial controller with all its dependencies
        let controller = assembler.resolver.resolve(LanguagesTableViewController.self)!
        
        let vc = UINavigationController(rootViewController: controller)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.black
        
        return true
    }
}
