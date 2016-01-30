//
//  ImageEntity.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/21/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Argo
import Curry
import CoreLocation

struct LanguageEntity {
    var abbr: String
    var name: String
    var sentence: String
    var flag: NSURL
    var not_right: Bool?
    
}

// MARK: Decodable

extension LanguageEntity: Decodable {

    
    static func decode(json: JSON) -> Decoded<LanguageEntity> {
        
        return curry(self.init)
            <^> json <| "abbr"
            <*> json <| "name"
            <*> json <| "sentence"
            <*> json <| "flag"
            <*> json <|? "not_right"
    }
}

