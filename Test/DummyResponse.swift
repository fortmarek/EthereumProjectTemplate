//
//  DummyResponse.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/23/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Foundation
@testable import SampleTestingProject

let dummyResponse: [LanguageEntity] = {
    let language0 = LanguageEntity(abbr: "en",
                                name: "English",
        sentence: "Who stole my unicorn?",
        flag: NSURL(string: "http://somewhere.com")!,
        not_right: nil,
        language_code: "en-EN"
    )
    
    
    let language1 = LanguageEntity(abbr: "cz",
        name: "Czech",
        sentence: "Kdo ukradl meho jednorozce?",
        flag: NSURL(string: "http://somewhere.com")!,
        not_right: nil,
        language_code: nil
    )
    
    return [language0, language1]
}()


