//
//  LanguagesAssembly.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject


typealias LanguageDetailModelingFactory = (language: LanguageEntity) -> LanguageDetailViewModeling
typealias LanguageDetailTableViewControllerFactory = (viewModel: LanguageDetailViewModeling) -> LanguageDetailViewController

class LanguagesAssembly: AssemblyType {
    
    func assemble(container: Container) {
        
        //MARK: View models
        
        // Example usage of unary ~ operator
        // Better to use container.register(initializer: LanguagesTableViewModel.init, service: LanguagesTableViewModeling.self) when possible
        container.register(LanguagesTableViewModeling.self) { r in
            LanguagesTableViewModel(api: r~, geocoder: r~, locationManager: r~, detailModelFactory: r~)
        }
        
        //Example usage of dynamic argument passing
        container.register(initializer:LanguageDetailViewModel.init, service: LanguageDetailViewModeling.self, argument: LanguageEntity.self)
        
        //MARK: View model factories
        
        // Factory for creating detail model
        container.registerFactory(LanguageDetailModelingFactory.self)
        
        //MARK: View controllers
        
        container.register(initializer: LanguagesTableViewController.init, service: LanguagesTableViewController.self)
        container.register(initializer: LanguageDetailViewController.init, service: LanguageDetailViewController.self, argument: LanguageDetailViewModeling.self)
        
        //MARK: View controller factories
        container.registerFactory(LanguageDetailTableViewControllerFactory.self)
    }

}
