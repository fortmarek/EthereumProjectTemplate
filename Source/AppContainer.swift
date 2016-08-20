//
//  AppContainer.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/27/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import CoreLocation
import HockeySDK
import AVFoundation

//Factories definition
typealias LanguageDetailTableViewControllerFactory = (viewModel: LanguageDetailViewModeling) -> LanguageDetailViewController
typealias LanguageDetailModelingFactory = (language: LanguageEntity) -> LanguageDetailViewModeling

class A {

}

class B {
    
}


class VM {
    init(b: B, a: A) {
        print(a, b)
        print("registered")
    }
}

class AppContainer {

    static let container = Container() { container in

        // ---- Models
        container.register(initializer: Network.init, service: Networking.self).inObjectScope(.Container)
        container.register(initializer: LanguagesAPIService.init, service: LanguagesAPIServicing.self).inObjectScope(.Container)
        container.register(initializer: Geocoder.init, service: Geocoding.self).inObjectScope(.Container)

        container.register(LocationManager.self, factory: { _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }).inObjectScope(.Container)

        container.register(initializer: SpeechSynthetizer.init, service: SpeechSynthetizing.self).inObjectScope(.Container)

        // ---- View models
        container.register(LanguagesTableViewModeling.self) { r in
            LanguagesTableViewModel(api: r~, geocoder: r~, locationManager: r~, detailModelFactory: r~)
        }
        //container.register(LanguagesTableViewModeling.self, initializer: LanguagesTableViewModel.init)
        //container.register(LanguageDetailViewModeling.self, initializer: LanguageDetailViewModel.init, argument: LanguageEntity.self)
        
        container.register(LanguageDetailViewModeling.self, factory: { r, language in
            LanguageDetailViewModel(language: language, synthetizer: r~)
        })
        
        // Factory for creating detail model
        container.registerFactory(LanguageDetailModelingFactory.self)
        
        // ---- Views
        container.register(initializer: LanguagesTableViewController.init, service: LanguagesTableViewController.self)
        container.register(initializer: LanguageDetailViewController.init, service: LanguageDetailViewController.self, argument: LanguageDetailViewModeling.self)
        
         // Factory for detail controller
        container.registerFactory(LanguageDetailTableViewControllerFactory.self)
        
        //Test
        container.register(initializer: VM.init, service: VM.self, arguments: (A.self, B.self))
        
        
    }
}
