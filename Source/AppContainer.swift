//
//  AppContainer.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/27/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import CoreLocation

class Factory{
    let r:ResolverType
    init(resolver:ResolverType){
        self.r = resolver
    }
}

protocol LanguageDetailTableViewControllerFactoring{
    func create(viewModel:LanguageDetailModeling)->LanguageDetailTableViewController
}


class AppContainer {
    
    static let container = Container() { container in
        // Models
        container.register(Networking.self) { _ in Network() }.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(API.self){ r in UnicornAPI(network: r.resolve(Networking.self)!)}.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(Geocoding.self){ r in Geocoder()}.inObjectScope(.Container) // <-- Will be created as singleton
        
        container.register(LocationManager.self){ _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }.inObjectScope(.Container)
        
        //https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md
        
        // View models
        container.register(LanguagesTableViewModeling.self) { r in
            return LanguagesTableViewModel(
                api: r.resolve(API.self)!,
                geocoder: r.resolve(Geocoding.self)!,
                locationManager: r.resolve(LocationManager.self)!,
                detailFactory: r.resolve(LanguageDetailTableViewControllerFactoring.self)! )
            }
        
        container.register(LanguageDetailModeling.self) { r, language in
            return LanguageDetailModel(language: language)
        }
        
        // Views
        container.register(LanguagesTableViewController.self) { r in
            return LanguagesTableViewController(viewModel: r.resolve(LanguagesTableViewModeling.self)!)
        }
        
        container.register(LanguageDetailTableViewControllerFactoring.self) { r in
            class LanguageDetailTableViewControllerFactory:Factory,LanguageDetailTableViewControllerFactoring{
                func create(viewModel:LanguageDetailModeling)->LanguageDetailTableViewController{
                    return LanguageDetailTableViewController(viewModel: viewModel)
                }
            }
            
            return LanguageDetailTableViewControllerFactory(resolver: r)
        }
    }
    
}
