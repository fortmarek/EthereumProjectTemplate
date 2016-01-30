//
//  AppContainer.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/27/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import CoreLocation

/*class Factory{
    let r:ResolverType
    init(resolver:ResolverType){
        self.r = resolver
    }
}

protocol LanguageDetailTableViewControllerFactoring{
    func create(viewModel:LanguageDetailModeling)->LanguageDetailTableViewController
}

container.register(LanguageDetailTableViewControllerFactoring.self) { r in
    class LanguageDetailTableViewControllerFactory:Factory,LanguageDetailTableViewControllerFactoring{
        func create(viewModel:LanguageDetailModeling)->LanguageDetailTableViewController{
            return LanguageDetailTableViewController(viewModel: viewModel)
        }
    }
    
    return LanguageDetailTableViewControllerFactory(resolver: r)
}
}*/

public struct Factory<T> {
    let factoryHandler: (AnyObject ... ) -> T
    
    public init(_ factoryHandler: (AnyObject ... ) -> T) {
        self.factoryHandler = factoryHandler
    }
    
    public func resolve(args:AnyObject ... )->T{
        return self.factoryHandler(args)
    }
}

import ReactiveCocoa


//Factories definition
typealias detailTableViewControllerFactory = (viewModel:LanguageDetailModeling) -> (LanguageDetailTableViewController)

class AppContainer {
    
    static let container = Container() { container in
        
        // ---- Models
        container.register(Networking.self) { _ in Network() }.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(API.self){ r in UnicornAPI(network: r.resolve(Networking.self)!)}.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(Geocoding.self){ r in Geocoder()}.inObjectScope(.Container) // <-- Will be created as singleton
        
        container.register(LocationManager.self){ _ in
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            return manager
        }.inObjectScope(.Container) // <-- Will be created as singleton
        
        
        
        // ---- View models
        container.register(LanguagesTableViewModeling.self) { r in
            return LanguagesTableViewModel(
                api: r.resolve(API.self)!,
                geocoder: r.resolve(Geocoding.self)!,
                locationManager: r.resolve(LocationManager.self)!,
                container: r.resolve(Container.self)! )
            }
        
        container.register(Factory<LanguagesTableViewModeling>.self) { r in
            return Factory<LanguagesTableViewModeling>{ _ in
                return LanguagesTableViewModel(
                    api: r.resolve(API.self)!,
                    geocoder: r.resolve(Geocoding.self)!,
                    locationManager: r.resolve(LocationManager.self)!,
                    container: r.resolve(Container.self)! )
            }
        }
        
        
        //Language passed as parameter
        container.register(LanguageDetailModeling.self) { r, language in
            return LanguageDetailModel(language: language)
        }
        
        // ---- Views
        
        container.register(LanguagesTableViewController.self) { r in
            return LanguagesTableViewController(viewModel:  r.resolve(LanguagesTableViewModeling.self)!)
        }
        
        
        
        
        container.register(SignalProducer<LanguagesTableViewController, NoError>.self) { r in
            return SignalProducer<LanguagesTableViewController, NoError>{ sink, disposable in
                let controller = r.resolve(LanguagesTableViewController.self)!
                sink.sendNext(controller)
                sink.sendCompleted()
            }
        }
        
        container.register(Factory<LanguagesTableViewController>.self) { r in
            return Factory<LanguagesTableViewController>{ _ in
                r.resolve(LanguagesTableViewController.self)!
            }
        }
        
        
        
        
        
        container.register(detailTableViewControllerFactory.self){ r in
            return { viewModel in
                return LanguageDetailTableViewController(viewModel: viewModel)
            }
        }
        
        //Detail controller -> passing it's view model as parameter
        
        
        /*container.register(Factory<LanguageDetailTableViewController>.self) { r in
            return Factory<LanguageDetailTableViewController>{ let viewModel:LanguageDetailModeling in
                return LanguageDetailTableViewController(viewModel: viewModel)
            }
        }*/
        
        
        
        //Have to register container so we can pass it as dependency
        container.register(Container.self) { r in
            return container
        }
        
        
    }
    
}
