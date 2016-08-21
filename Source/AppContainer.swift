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
        // Example usage of unary ~ operator
        // Better to use container.register(initializer: LanguagesTableViewModel.init, service: LanguagesTableViewModeling.self) when possible
        container.register(LanguagesTableViewModeling.self) { r in
            return LanguagesTableViewModel(api: r~, geocoder: r~, locationManager: r~, detailModelFactory: r~)
        }
        
        //Example usage of dynamic argument passing
        container.register(initializer:LanguageDetailViewModel.init, service: LanguageDetailViewModeling.self, argument: LanguageEntity.self)
        
        
        // Factory for creating detail model
        container.registerFactory(LanguageDetailModelingFactory.self)
        
        // ---- Views
        container.register(initializer: LanguagesTableViewController.init, service: LanguagesTableViewController.self)
        container.register(initializer: LanguageDetailViewController.init, service: LanguageDetailViewController.self, argument: LanguageDetailViewModeling.self)
        
         // Factory for detail controller
        container.registerFactory(LanguageDetailTableViewControllerFactory.self)
        
    }
}
