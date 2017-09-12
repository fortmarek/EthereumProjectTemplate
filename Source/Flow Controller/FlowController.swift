//
//  FlowController.swift
//  ProjectSkeleton
//
//  Created by Lukáš Hromadník on 12.09.17.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

protocol FlowController: class, RoutingProvider {
    var children: [FlowController] { get set }
    
    func start()
}

extension FlowController {
    
    func add(child flowController: FlowController) {
        children.append(flowController)
        flowController.start()
    }

}
