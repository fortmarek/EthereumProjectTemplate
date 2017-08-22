//
//  LanguageDetailViewModel.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveSwift
import AVFoundation

protocol LanguageDetailViewModeling {
    var name: MutableProperty<String> { get }
    var sentence: MutableProperty<String> { get }
    var flagURL: MutableProperty<URL> { get }
    var isSpeaking: MutableProperty<Bool> { get }

    var playSentence: Action<Void, (), SpeakError> {get}

}

class LanguageDetailViewModel: LanguageDetailViewModeling {
    let name: MutableProperty<String>
    let flagURL: MutableProperty<URL>
    let sentence: MutableProperty<String>
    let language_code: MutableProperty<String?>
    let isSpeaking: MutableProperty<Bool>

    fileprivate let language: Language

    fileprivate let synthetizer: SpeechSynthetizing

    internal init(language: Language, synthetizer: SpeechSynthetizing) {
        self.language = language
        self.name = MutableProperty(language.name)
        self.flagURL = MutableProperty(URL(string: language.flag)!)
        self.sentence = MutableProperty(language.sentence)
        self.language_code = MutableProperty(language.language_code)
        self.synthetizer = synthetizer

        self.isSpeaking = MutableProperty(false)

        self.setupBindings()
    }

    func setupBindings() {
        isSpeaking <~ self.synthetizer.isSpeaking
    }

    lazy var playSentence: Action<Void, (), SpeakError> = { [unowned self] in
        let canPlaySentence = self.language.language_code.flatMap { self.synthetizer.canSpeakLanguage($0) } == true ?
            Property(initial: false, then: self.synthetizer.isSpeaking.producer.map {!$0}) : Property(value: false)
        return Action(enabledIf: canPlaySentence) { [unowned self] _ in
            let code = self.language.language_code! //if theres no code, this action is disabled
            return self.synthetizer.speakSentence(self.language.sentence, language: code)
        }
    }()
}
