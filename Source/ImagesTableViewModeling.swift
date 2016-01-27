//
//  ImagesTableViewModelling.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import ReactiveCocoa

protocol ImagesTableViewModeling {
    var cellModels: MutableProperty<[ImagesTableViewCellModeling]> { get }
    var loading: MutableProperty<Bool>{ get }
    var errorMessage: MutableProperty<String?> { get }
    var loadImages: Action<(), [ImageEntity], NSError> { get }
    
}
