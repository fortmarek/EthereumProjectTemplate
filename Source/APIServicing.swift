//
//  APIServicing.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift

//Describe protocols for all APIs

protocol LanguagesAPIServicing {
    func languages() -> SignalProducer<[LanguageEntity], RequestError>
}

protocol AuthenticationAPIServicing {
    func login(_ username: String, password: String) -> SignalProducer<(UserEntity, Credentials), RequestError>
}


protocol SomethingElseAPIServicing {
    // You can divide functionality in different API Services
}
