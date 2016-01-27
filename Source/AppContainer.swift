//
//  AppContainer.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/27/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject

class AppContainer {
    
    static let container = Container() { container in
        // Models
        container.register(Networking.self) { _ in Network() }.inObjectScope(.Container) // <-- Will be created as singleton
        container.register(API.self){ r in PixabayAPI(network: r.resolve(Networking.self)!)}.inObjectScope(.Container) // <-- Will be created as singleton
        
        //https://github.com/Swinject/Swinject/blob/master/Documentation/ObjectScopes.md
        
        // View models
        container.register(ImagesTableViewModeling.self) { r in
            return ImagesTableViewModel(api: r.resolve(API.self)!)
            }
        
        
        // Views
        container.register(ImagesTableViewController.self) { r in
            return ImagesTableViewController(viewModel: r.resolve(ImagesTableViewModeling.self)!)
        }
    }
    
}
