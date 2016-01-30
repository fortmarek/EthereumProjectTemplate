//
//  ImagesTableViewModelling.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import ReactiveCocoa
import Swinject

protocol LanguagesTableViewModeling {
    var cellModels: MutableProperty<[LanguageDetailModeling]> { get }
    var loading: MutableProperty<Bool>{ get }
    var errorMessage: MutableProperty<String?> { get }
    var loadLanguages: Action<(), (LanguageEntity, CLLocation?), NSError> { get }
    
    var container: Container { get }
}
