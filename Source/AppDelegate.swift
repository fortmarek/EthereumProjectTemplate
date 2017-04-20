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
import ProjectSkeletonFramework
import ACKReactiveExtensions
import ACKategories


class AppDelegate: BaseAppDelegate {

    override var delegates: [UIApplicationDelegate] {
        return [
            HockeySDKAppDelegate(),
            MainAppDelegate()
        ]
    }
}
