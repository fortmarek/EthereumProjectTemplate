//
//  ImagesTableViewCellModeling.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa

protocol LanguageDetailViewModeling {
    var name: MutableProperty<String> { get }
    var sentence: MutableProperty<String> { get }
    var flagURL : MutableProperty<NSURL> { get }
    var canPlaySentence: MutableProperty<Bool> { get }
    var isSpeaking: MutableProperty<Bool> { get }
    
    var playSentence: Action<UIButton, (), NSError> {get}
    
}
