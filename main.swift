//
//  main.swift.swift
//  ProjectSkeleton
//
//  Created by Jakub Olejník on 15/03/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation

import UIKit

let appDelegateClass: AnyClass? = NSClassFromString("Tests.TestingAppDelegate") ?? AppDelegate.self

let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
    to: UnsafeMutablePointer<Int8>.self,
    capacity: Int(CommandLine.argc)
)

UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(appDelegateClass!))

