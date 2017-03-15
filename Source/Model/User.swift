//
//  User.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 2/8/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

//import CoreValue
import Foundation
import CoreData
import Argo
import Runes
import Curry

struct User {
    let id: Int
    //let username: String
}

extension User: Decodable {
    static func decode(_ json: JSON) -> Decoded<User> {
        return curry(self.init)
            <^> json <| "id"
    }
}
