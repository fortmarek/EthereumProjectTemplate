//
//  ImagesTableViewCellModeling.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

protocol LanguageDetailModeling {
    var name: String { get }
    var flagURL : NSURL { get }
}
