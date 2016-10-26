//
//  ServiceAssembly.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject

class ServiceAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        container.autoregister(Networking.self, initializer: Network.init).inObjectScope(.container)
        container.autoregister(LanguagesAPIServicing.self, initializer: LanguagesAPIService.init).inObjectScope(.container)
    }

}
