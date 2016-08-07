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
        container.registerAuto(Networking.self, initializer: Network.init).inObjectScope(.Container)
        container.registerAuto(LanguagesAPIServicing.self, initializer: LanguagesAPIService.init).inObjectScope(.Container)
        container.registerAuto(Geocoding.self, initializer: Geocoder.init).inObjectScope(.Container)

        container.register(LocationManager.self) { _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }.inObjectScope(.Container)

        container.registerAuto(SpeechSynthetizing.self, initializer: SpeechSynthetizer.init).inObjectScope(.Container)

        // ---- View models
        container.registerAuto(LanguagesTableViewModeling.self, initializer: LanguagesTableViewModel.init)
        container.registerAuto(LanguageDetailViewModeling.self, initializer: LanguageDetailViewModel.init, argument: LanguageEntity.self)
        
        // Factory for creating detail model
        container.registerFactory(LanguageDetailModelingFactory.self)
        
        // ---- Views
        container.registerAuto(LanguagesTableViewController.self, initializer: LanguagesTableViewController.init)
        container.registerAuto(LanguageDetailViewController.self, initializer: LanguageDetailViewController.init, argument: LanguageDetailViewModeling.self)
        
         // Factory for detail controller
        container.registerFactory(LanguageDetailTableViewControllerFactory.self)
        
    }
}
