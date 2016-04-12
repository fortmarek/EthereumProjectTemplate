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
        container.register(Networking.self) { _ in Network() }.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(LanguagesAPIServicing.self) { r in LanguagesAPIService(network: r.resolve(Networking.self)!)}.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(Geocoding.self) { r in Geocoder()}.inObjectScope(.Container) // <-- Will be created as singleton

        container.register(LocationManager.self) { _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
            }.inObjectScope(.Container) // <-- Will be created as singleton


        container.register(BITHockeyManager.self) { (r, delegate: BITHockeyManagerDelegate) in
            let hockeyManager = BITHockeyManager.sharedHockeyManager()
            hockeyManager.configureWithIdentifier(Environment.Hockey.identifier, delegate: delegate)
            return hockeyManager
        }.inObjectScope(.Container)

        container.register(SpeechSynthetizing.self) { _ in SpeechSynthetizer() }.inObjectScope(.Container)


        // ---- View models
        container.register(LanguagesTableViewModeling.self) { r in
            return LanguagesTableViewModel(
                api: r.resolve(LanguagesAPIServicing.self)!,
                geocoder: r.resolve(Geocoding.self)!,
                locationManager: r.resolve(LocationManager.self)!,
                detailModelFactory: r.resolve(LanguageDetailModelingFactory.self)! )
        }


        // Factory for creating detail model
        container.register(LanguageDetailModelingFactory.self) { r in
            return { language in
                return LanguageDetailViewModel(language: language, synthetizer: r.resolve(SpeechSynthetizing.self)!)
            }
        }

        // ---- Views

        container.register(LanguagesTableViewController.self) { r in
            return LanguagesTableViewController(
                viewModel:  r.resolve(LanguagesTableViewModeling.self)!,
                detailControllerFactory: r.resolve(LanguageDetailTableViewControllerFactory.self)!)
        }


        //Factory for detail controller
        container.register(LanguageDetailTableViewControllerFactory.self) { r in
            return { viewModel in
                return LanguageDetailViewController(viewModel: viewModel)
            }
        }




    }

}
