//
//  ImageSearchTableViewCellModel.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ReactiveCocoa
import AVFoundation

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
