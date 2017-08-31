//
//  RoutingAction.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 22/08/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation

// Routing action that are used in flow controllers
// Define all possible actions here

public enum RoutingAction  {
   
    
    //MARK: Parsing
    static func parseNotification(userInfo:[String: Any]) -> RoutingAction? {
        return nil
    }
    
    static func parseShortcut(type: String) -> RoutingAction? {
        return nil
    }
    
    static func parseDeeplink(url: String) -> RoutingAction? {
        return nil
    }
    
    static func parseFirebaseObservation(data : [AnyHashable: Any]) -> RoutingAction? {
        return nil
    }
}
