//
//  AuthHandler.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 27/01/2017.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift

class AuthHandler: AuthHandling {
    //    let userManager: UserManaging
    //
    //    init(userManager: UserManaging){
    //        self.userManager = userManager
    //    }
    
    lazy var refreshAction: Action<NetworkError, (), UserError> = Action { [unowned self] _ in
        
        assertionFailure("Implement refresh action!")
        return .empty
        
//        return self.userManager.refresh().observe(on: UIScheduler()).map { _ in }.on ( failed: { _ in
//            self.userManager.logout().start()
//            
//            let controller = self.router.prepare(vc: LoginViewController.self)
//            UIApplication.shared.keyWindow?.rootViewController = controller
//        })
    }
}
