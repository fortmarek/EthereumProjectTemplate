//
//  ManagerAssembly.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import ACKSwinject
import CoreLocation

class ManagerAssembly: AssemblyType {
    
    func assemble(container: Container) {
        container.register(initializer: Geocoder.init, service: Geocoding.self).inObjectScope(.Container)
        
        container.register(LocationManager.self, factory: { _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }).inObjectScope(.Container)
        
        container.register(initializer: SpeechSynthetizer.init, service: SpeechSynthetizing.self).inObjectScope(.Container)
    }

}
