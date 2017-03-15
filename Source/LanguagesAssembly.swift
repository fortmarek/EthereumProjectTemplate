//
//  LanguagesAssembly.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

typealias LanguageDetailModelingFactory = (_ language: LanguageEntity) -> LanguageDetailViewModeling
typealias LanguageDetailTableViewControllerFactory = (_ viewModel: LanguageDetailViewModeling) -> LanguageDetailViewController

class LanguagesAssembly: Assembly {
    
    func assemble(container: Container) {
        
        //MARK: View models
        //Example use of specific initializer
        container.autoregister(LanguagesTableViewModeling.self, initializer: LanguagesTableViewModel.init(api:geocoder:locationManager:detailModelFactory:))

        // For more specific cases you can use unary operator ~>
//        container.register(LanguagesTableViewModeling.self) { r in
//            return LanguagesTableViewModel(api: r~>, geocoder: r~>, locationManager: r~>, detailModelFactory: r~>)
//        }
        
        //Example usage of dynamic argument passing
        container.autoregister(LanguageDetailViewModeling.self, argument: LanguageEntity.self, initializer: LanguageDetailViewModel.init(language:synthetizer:))
        
        //MARK: View model factories
        
        // Factory for creating detail model
        container.autoregisterFactory(factory: LanguageDetailModelingFactory.self)
        
        //MARK: View controllers
        
        container.autoregister(LanguagesTableViewController.self, initializer: LanguagesTableViewController.init)
        container.autoregister(LanguageDetailViewController.self, argument: LanguageDetailViewModeling.self, initializer: LanguageDetailViewController.init)
        
        //MARK: View controller factories
        container.autoregisterFactory(factory: LanguageDetailTableViewControllerFactory.self)
    }

}
