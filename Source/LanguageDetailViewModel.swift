//
//  LanguageDetailViewModel.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa
import AVFoundation

protocol LanguageDetailViewModeling {
    var name: MutableProperty<String> { get }
    var sentence: MutableProperty<String> { get }
    var flagURL: MutableProperty<NSURL> { get }
    var isSpeaking: MutableProperty<Bool> { get }

    var playSentence: Action<AnyObject, (), SpeakError> {get}

}

class LanguageDetailViewModel: LanguageDetailViewModeling {
    let name: MutableProperty<String>
    let flagURL: MutableProperty<NSURL>
    let sentence: MutableProperty<String>
    let language_code: MutableProperty<String?>
    let isSpeaking: MutableProperty<Bool>

    private let language: LanguageEntity

    private let synthetizer: SpeechSynthetizing

    internal init(language: LanguageEntity, synthetizer: SpeechSynthetizing) {
        self.language = language
        self.name = MutableProperty(language.name)
        self.flagURL = MutableProperty(NSURL(string: language.flag)!)
        self.sentence = MutableProperty(language.sentence)
        self.language_code = MutableProperty(language.language_code)
        self.synthetizer = synthetizer

        self.isSpeaking = MutableProperty(false)

        self.setupBindings()
    }

    func setupBindings() {
        isSpeaking <~ self.synthetizer.isSpeaking
    }

    lazy var playSentence: Action<AnyObject, (), SpeakError> = { [unowned self] in
        let canPlaySentence = self.language.language_code.flatMap { self.synthetizer.canSpeakLanguage($0) } == true ?
            AnyProperty(initialValue: false, producer: self.synthetizer.isSpeaking.producer.map {!$0}) :
            AnyProperty(ConstantProperty(false))
        return Action(enabledIf: canPlaySentence) { [unowned self] _ in
            let code = self.language.language_code! //if theres no code, this action is disabled
            return self.synthetizer.speakSentence(self.language.sentence, language: code)
        }
    }()
}
