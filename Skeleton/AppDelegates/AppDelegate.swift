//
//  AppDelegate.swift
//  Skeleton
//
//  Created by Jakub Olejník on 09/10/2017.
//

import UIKit

final class AppDelegate: BaseAppDelegate {

    private let mainDelegate = MainAppDelegate()
    
    override var window: UIWindow? {
        get { return mainDelegate.window }
        set { mainDelegate.window = newValue }
    }
    
    override var delegates: [UIApplicationDelegate] {
        return [
            mainDelegate
        ]
    }
}
