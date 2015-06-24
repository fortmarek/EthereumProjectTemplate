//
//  Model.swift
//  Rekola
//
//  Created by Dominik Vesely on 11/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import Argo
import Runes


////MARK: logininfo

public struct LoginInfo {
    let apiKey : String
    let terms : Bool
}

extension LoginInfo : Decodable {
    static func create(apiKey: String)(terms: Bool) -> LoginInfo {
        return LoginInfo(apiKey: apiKey, terms: terms)
    }
    
    public static func decode(j: JSON) -> Decoded<LoginInfo> {
        return LoginInfo.create
            <^> j <| "apiKey"
            <*> j <| "terms"
    }
}



