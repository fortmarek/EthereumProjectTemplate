//
//  FirebaseAppDelegate.swift
//  Skeleton
//
//  Created by Jakub Olejník on 09/12/2017.
//

import Firebase

final class FirebaseAppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
}
