//
//  AppDelegate.swift
//  ProjectSkeleton
//
//  Created by Dominik Vesely on 07/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveSwift
import HockeySDK
import Swinject

import ACKReactiveExtensions
import ACKategories

import enum Result.NoError
public typealias NoError = Result.NoError

class AppDelegate: UIResponder, UIApplicationDelegate, BITHockeyManagerDelegate {

    var window: UIWindow?
    
    var assembler: Assembler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Assemble!
        assembler = try! Assembler(assemblies: [
            AppAssembly(),
            ServiceAssembly(),
            ManagerAssembly(),
            LanguagesAssembly()
        ])
        
        // Start Hockey Manager
        if Environment.Hockey.identifier.characters.count != 0 && Environment.Hockey.allowLogging {
            let hockeyManager = BITHockeyManager.shared()
            hockeyManager.configure(withIdentifier: Environment.Hockey.identifier, delegate: self)
            hockeyManager.start()
            hockeyManager.authenticator.authenticateInstallation()
            hockeyManager.crashManager.crashManagerStatus = .autoSend
        }

        // Start location manager
        let locationManager = assembler.resolver.resolve(LocationManager.self)!
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Resolve initial controller with all its dependencies
        let controller = assembler.resolver.resolve(LanguagesTableViewController.self)!

        let vc = UINavigationController(rootViewController: controller)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.black

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func crashManagerWillSendCrashReport(_ crashManager: BITCrashManager!) {
    }

    func crashManagerWillSendCrashReportsAlways(_ crashManager: BITCrashManager!) {
    }

    func crashManagerDidFinishSendingCrashReport(_ crashManager: BITCrashManager!) {
    }

    func crashManagerWillCancelSendingCrashReport(_ crashManager: BITCrashManager!) {
    }
}
