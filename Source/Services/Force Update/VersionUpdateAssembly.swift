//
//  VersionUpdateAssembly.swift
//  ProjectSkeleton
//
//  Created by Lukáš Hromadník on 21.08.17.
//  Copyright © 2017 Ackee s.r.o. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

class VersionUpdateAssembly: Assembly {
    
    func assemble(container: Container) {
        container.autoregister(VersionUpdateManaging.self, initializer: VersionUpdateManager.init)
//        container.register(Fetcher.self) { _ in FirebaseFetcher(key: "min_build_number_ios") }
//        container.register(Fetcher.self) { _ in APIFetcher(url: "https://www.whostolemyunicorn.cz/api/v1/guid.php", keyPath: "guid") }
    }
    
}
