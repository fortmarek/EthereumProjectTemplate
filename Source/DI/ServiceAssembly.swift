//
//  ServiceAssembly.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject

class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        //Uncomment for authenticated service
        //container.autoregister(AuthHandling.self, initializer: AuthHandler.init).inObjectScope(.container)
        //container.register(AuthorizationProvider.self){ r in r ~> UserManaging.self }
        container.autoregister(Networking.self, initializer: Network.init).inObjectScope(.container)
        container.autoregister(LanguagesAPIServicing.self, initializer: LanguagesAPIService.init).inObjectScope(.container)
    }

}
