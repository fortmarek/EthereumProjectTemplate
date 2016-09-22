//
//  DummyResponse.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 8/23/15.
//  Copyright © 2015 Ackee s. r. o. All rights reserved.
//

import Foundation
@testable import ProjectSkeleton

let dummyResponse: [LanguageEntity] = {
    let language0 = LanguageEntity(abbr: "en",
                                name: "English",
        sentence: "Who stole my unicorn?",
        flag: "http://somewhere.com",
        not_right: nil,
        language_code: "en-EN"
    )
    
    
    let language1 = LanguageEntity(abbr: "cz",
        name: "Czech",
        sentence: "Kdo ukradl meho jednorozce?",
        flag: "http://somewhere.com",
        not_right: nil,
        language_code: nil
    )
    
    return [language0, language1]
}()


