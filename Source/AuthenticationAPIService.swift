//
//  AuthenticationAPIService.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa

class AuthenticationAPIService: APIService, AuthenticationAPIServicing {
    func login(username: String, password: String) -> SignalProducer<(UserEntity, Credentials), RequestError> {
        //TODO: Implement login
        return SignalProducer.empty
    }
}
