//
//  ImagesTableViewCellModeling.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

protocol ImagesTableViewCellModeling {
    var id: Int { get }
    var text: String { get }
    var previewImageURL: NSURL { get }
    
}
