//
//  APIServicing.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

protocol API {
    func loadImages(page: Int) -> SignalProducer<[ImageEntity],NSError>
}
