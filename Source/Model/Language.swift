//
//  Language.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/21/15.
//  Copyright © 2015 Ackee s. r. o. All rights reserved.
//

import Argo
import Runes
import Curry

struct Language {
    var abbr: String
    var name: String
    var sentence: String
    var flag: String
    var not_right: Bool?
    var language_code: String?
}

// MARK: Decodable

extension Language: Decodable {
    static func decode(_ json: JSON) -> Decoded<Language> {
        return curry(self.init)
            <^> json <| "abbr"
            <*> json <| "name"
            <*> json <| "sentence"
            <*> json <| "flag"
            <*> json <|? "not_right"
            <*> json <|? "language_code"
    }
}
