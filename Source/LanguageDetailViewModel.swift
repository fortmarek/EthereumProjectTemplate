//
//  LanguageDetailViewModel.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa
import AVFoundation

protocol LanguageDetailViewModeling {
    var name: MutableProperty<String> { get }
    var sentence: MutableProperty<String> { get }
    var flagURL : MutableProperty<NSURL> { get }
    var canPlaySentence: MutableProperty<Bool> { get }
    var isSpeaking: MutableProperty<Bool> { get }
    
    var playSentence: Action<UIButton, (), NSError> {get}
    
}

class LanguageDetailViewModel:  LanguageDetailViewModeling {
    let name: MutableProperty<String>
    let flagURL : MutableProperty<NSURL>
    let sentence : MutableProperty<String>
    let language_code : MutableProperty<String?>
    var canPlaySentence: MutableProperty<Bool>
    var isSpeaking: MutableProperty<Bool>
    
    private let language:LanguageEntity
    
    private let synthetizer:SpeechSynthetizing
    
    internal init(language: LanguageEntity, synthetizer: SpeechSynthetizing) {
        self.language = language
        self.name = MutableProperty(language.name)
        self.flagURL = MutableProperty(language.flag)
        self.sentence = MutableProperty(language.sentence)
        self.language_code = MutableProperty(language.language_code)
        self.synthetizer = synthetizer
        
        self.canPlaySentence = MutableProperty(false)
        self.isSpeaking = MutableProperty(false)
        
        self.setupBindings()
    }
    
    func setupBindings(){
        if let code = language.language_code where self.synthetizer.canSpeakLanguage(code) {
            canPlaySentence <~ self.synthetizer.isSpeaking.producer.map{!$0}
        }
        
        isSpeaking <~ self.synthetizer.isSpeaking
    }
    
    var playSentence: Action<UIButton, (), NSError> {
        return Action(enabledIf: canPlaySentence) { _ in
            if let code = self.language.language_code {
                return self.synthetizer.speakSentence(self.language.sentence, language: code)
            }
            
            return SignalProducer.empty
        }
    }
}
