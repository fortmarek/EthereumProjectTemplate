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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , BITHockeyManagerDelegate {
	
	var window: UIWindow?
    
    
    
    
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        /*if Environment.Hockey.identifier.characters.count == 0 {
            NSException(name: "Illegal state exception", reason: "Hockey app is not configured.", userInfo: nil).raise()
        }*/
        
        if Environment.Hockey.identifier.characters.count != 0 && Environment.Hockey.allowLogging {
            BITHockeyManager.sharedHockeyManager().configureWithIdentifier(Environment.Hockey.identifier, delegate: self)
            BITHockeyManager.sharedHockeyManager().startManager()
            BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()
            BITHockeyManager.sharedHockeyManager().crashManager.crashManagerStatus = .AutoSend
        }
        
        
        //Load App Container
        let appContainer = AppContainer.container
        
        let locationManager = appContainer.resolve(LocationManager.self)!
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //Resolve initial controller with all its dependencies
        let controller = appContainer.resolve(LanguagesTableViewController.self)!
        
		let vc = UINavigationController(rootViewController: controller)
		
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = vc
		window?.makeKeyAndVisible()
		window?.tintColor = UIColor.whiteColor()
	
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
	
}

