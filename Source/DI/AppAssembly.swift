//
//  LaunchAssembly.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject

import UIKit
import enum Result.NoError
public typealias NoError = Result.NoError

class AppAssembly: Assembly {
    
    func assemble(container: Container) {
        container.autoregister(AppFlowController.self, argument: UIWindow.self, initializer: AppFlowController.init)
    }
}
