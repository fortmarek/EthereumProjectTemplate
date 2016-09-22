//
//  ServiceAssembly.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import ACKSwinject

class ServiceAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        container.register(initializer: Network.init, service: Networking.self).inObjectScope(.Container)
        container.register(initializer: LanguagesAPIService.init, service: LanguagesAPIServicing.self).inObjectScope(.Container)
    }

}
