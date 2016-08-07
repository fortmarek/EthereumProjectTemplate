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
        container.register(Networking.self, initializer: Network.init).inObjectScope(.Container)
        container.register(LanguagesAPIServicing.self, initializer: LanguagesAPIService.init).inObjectScope(.Container)
        container.register(Geocoding.self, initializer: Geocoder.init).inObjectScope(.Container)

        container.register(LocationManager.self, factory: { _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }).inObjectScope(.Container)

        container.register(SpeechSynthetizing.self, initializer: SpeechSynthetizer.init).inObjectScope(.Container)

        // ---- View models
        container.register(LanguagesTableViewModeling.self, initializer: LanguagesTableViewModel.init)
        container.register(LanguageDetailViewModeling.self, initializer: LanguageDetailViewModel.init, argument: LanguageEntity.self)
        
        // Factory for creating detail model
        container.registerFactory(LanguageDetailModelingFactory.self)
        
        // ---- Views
        container.register(LanguagesTableViewController.self, initializer: LanguagesTableViewController.init)
        container.register(LanguageDetailViewController.self, initializer: LanguageDetailViewController.init, argument: LanguageDetailViewModeling.self)
        
         // Factory for detail controller
        container.registerFactory(LanguageDetailTableViewControllerFactory.self)
        
    }
}
