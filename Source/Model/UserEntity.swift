//
//  UserEntity.swift
//  CoreMapper
//
//  Created by Tomas Kohout on 2/8/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

//import CoreValue
import Foundation
import CoreData
import Argo
import Curry

struct UserEntity {
    let id: Int
    //let username: String
}

extension UserEntity: Decodable {
    static func decode(json: JSON) -> Decoded<UserEntity> {
        return curry(self.init)
            <^> json <| "id"
    }
}
