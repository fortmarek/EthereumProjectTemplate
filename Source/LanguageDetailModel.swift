//
//  ImageSearchTableViewCellModel.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ReactiveCocoa

class LanguageDetailModel:  LanguageDetailModeling {
    let name: String
    let flagURL : NSURL
    
    internal init(language: LanguageEntity) {
        name = language.name
        flagURL = language.flag
        
    }
    
}
