//
//  APIServicing.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa

//Describe protocols for all APIs

protocol LanguagesAPIServicing {
    func languages() -> SignalProducer<[LanguageEntity], RequestError>
}

protocol SomethingElseAPIServicing {
    // You can divide functionality in different API Services
}
