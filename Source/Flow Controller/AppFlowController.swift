//
//  AppFlowController.swift
//  ProjectSkeleton
//
//  Created by Lukáš Hromadník on 12.09.17.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import UIKit

final class AppFlowController: FlowController {
    var children = [FlowController]()
    
    private var window: UIWindow
    
    // MARK: Initializers
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: Flow controller
    
    func start() {
        let circuitNav = UINavigationController()
        
        // Create flow controller for given flow and
        // append children array with new flow controller
        // add(child: newFlowController)
        
        window.rootViewController = circuitNav
    }

}
