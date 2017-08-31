//
//  FlowController.swift
//  Kosik
//
//  Created by Tomas Kohout on 09/06/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation

protocol FlowController: class, RoutingProvider {
    var childControllers: [FlowController] {get set}
    
    func addChild(_ flowController: FlowController)

    func handle(action: RoutingAction)
    
}

extension FlowController {
    func addChild(_ flowController: FlowController) {
        if !childControllers.contains { $0 === flowController } {
            childControllers.append(flowController)
        }
    }
    
    func removeChild(_ flowController: FlowController) {
        if let index = childControllers.index (where: { $0 === flowController }) {
            childControllers.remove(at: index)
        }
    }
    
    func handle(action: RoutingAction) {
        
    }
    
    func dispatch(action: RoutingAction) {
        handle(action: action)
        childControllers.forEach { (flowController) in
            flowController.dispatch(action: action)
        }
    }
    
}
