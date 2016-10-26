//
//  Credentials.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 2/26/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry
import Locksmith

struct Credentials {
    let access_token: String
    let expires_in: Int
    let token_type: String
    let scope: String
    let refresh_token: String
    var id: Int?

    init(access_token: String, expires_in: Int, token_type: String, scope: String, refresh_token: String, id: Int? = nil) {
        self.id = id
        self.access_token = access_token
        self.expires_in = expires_in
        self.token_type = token_type
        self.scope = scope
        self.refresh_token = refresh_token
    }

    init?(data: [String: Any]?) {
        if let data = data, let id = data["id"] as? Int, let access_token = data["access_token"] as? String, let refresh_token = data["refresh_token"] as? String, let expires_in = data["expires_in"] as? Int, let scope = data["scope"] as? String, let token_type = data["token_type"] as? String {
                self.init(access_token: access_token, expires_in: expires_in, token_type: token_type, scope: scope, refresh_token: refresh_token, id: id)
                
        } else {
            return nil
        }
    }
    
    func toKeychainData() -> [String: Any]? {
        if let id = self.id {
            return ["access_token": access_token as AnyObject, "refresh_token": refresh_token as AnyObject, "expires_in": expires_in as AnyObject, "scope": scope as AnyObject, "token_type": token_type as AnyObject, "id": id as AnyObject]
        }
        return nil
    }
}

extension Credentials: Decodable {
    static func decode(_ json: JSON) -> Decoded<Credentials> {
        return
            curry(self.init)
                <^> json <| "access_token"
                <*> json <| "expires_in"
                <*> json <| "token_type"
                <*> json <| "scope"
                <*> json <| "refresh_token"
                <*> .success(nil)
    }
}
