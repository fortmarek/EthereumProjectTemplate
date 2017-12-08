//
//  MainAppDelegate.swift
//  Skeleton
//
//  Created by Jakub Olejník on 08/12/2017.
//

import UIKit

final class MainAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AckeeViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
