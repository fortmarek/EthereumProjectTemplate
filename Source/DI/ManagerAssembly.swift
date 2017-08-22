//
//  ManagerAssembly.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import CoreLocation

class ManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.autoregister(Geocoding.self, initializer: Geocoder.init).inObjectScope(.container)
        
        container.register(LocationManager.self, factory: { _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }).inObjectScope(.container)
        
        container.autoregister(SpeechSynthetizing.self, initializer: SpeechSynthetizer.init).inObjectScope(.container)
    }

}
