//
//  AppDelegate.swift
//  SwiftPokus
//
//  Created by Dominik Vesely on 07/04/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import ReactiveCocoa
import HockeySDK
import Swinject
import enum Result.NoError

public typealias NoError = Result.NoError

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BITHockeyManagerDelegate {

    var window: UIWindow?
    
    var assembler: Assembler!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Assemble!
        assembler = try! Assembler(assemblies: [
            LaunchAssembly(),
            ServiceAssembly(),
            ManagerAssembly(),
            LanguagesAssembly()
        ])
        
        // in this example, reauthentication is handled through UI, so we have to inject an AuthHandler for apiservices to use.
        // in your app, reauth could just be a refresh token request done by the api service instead, so theres no need to pass AuthHandler as parameter to APIService.init.
        // be aware that all APIServices that talk to the same api should use the same AuthHandler (even if we split functionality into multiple APIService). So dont create a separate AuthHandler for each sub-APIService.
        (assembler.resolver as? Container)?.register(AuthHandler.self, factory: { [unowned self] _ in self.refreshTokenAction }).inObjectScope(.Container)
        
        
        
        // Start Hockey Manager
        if Environment.Hockey.identifier.characters.count != 0 && Environment.Hockey.allowLogging {
            let hockeyManager = BITHockeyManager.sharedHockeyManager()
            hockeyManager.configureWithIdentifier(Environment.Hockey.identifier, delegate: self)
            hockeyManager.startManager()
            hockeyManager.authenticator.authenticateInstallation()
            hockeyManager.crashManager.crashManagerStatus = .AutoSend
        }

        // Start location manager
        let locationManager = assembler.resolver.resolve(LocationManager.self)!
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

         assembler.resolver.resolve(UIViewController.self)
        
        // Resolve initial controller with all its dependencies
        let controller = assembler.resolver.resolve(LanguagesTableViewController.self)!

        let vc = UINavigationController(rootViewController: controller)

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        window?.tintColor = UIColor.blackColor()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func crashManagerWillSendCrashReport(crashManager: BITCrashManager!) {
    }

    func crashManagerWillSendCrashReportsAlways(crashManager: BITCrashManager!) {
    }

    func crashManagerDidFinishSendingCrashReport(crashManager: BITCrashManager!) {
    }

    func crashManagerWillCancelSendingCrashReport(crashManager: BITCrashManager!) {
    }

    lazy var refreshTokenAction: AuthHandler = { [unowned self] in
        Action { [unowned self] _ in
            SignalProducer { [unowned self] sink, dis in
//                self.window?.rootViewController?.frontmostController.presentViewController(UIViewController(), animated: true) { _ in } //present login controller, send completed when new token is set or error if we cant login.
                sink.sendCompleted()
            }
        }
    }()
}
