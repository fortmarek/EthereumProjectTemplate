//
//  MainAppDelegate.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 07/04/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation
import UIKit
import SwinjectAutoregistration

public class MainAppDelegate: NSObject, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    private let assembler = AppAssembler
    private lazy var appFlowController: AppFlowController = self.assembler.resolver ~> (AppFlowController.self, argument: self.window!)
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        appFlowController.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}
