//
//  SpeechSynthetizer.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import AVFoundation
import ReactiveSwift

protocol SpeechSynthetizing {
    var isSpeaking: MutableProperty<Bool> { get }
    func canSpeakLanguage(_ language: String) -> Bool
    func speakSentence(_ sentence: String, language: String) -> SignalProducer<(), SpeakError>
}

enum SpeakError: Error {
    case languageUnavaible(String)
    case cancelled
}

class SpeechSynthetizer: NSObject, SpeechSynthetizing, AVSpeechSynthesizerDelegate {
    let synthetizer: AVSpeechSynthesizer

    override init() {
        self.synthetizer = AVSpeechSynthesizer()
        super.init()
    }

    var isSpeaking = MutableProperty<Bool>(false)

    func canSpeakLanguage(_ language: String) -> Bool {

        return AVSpeechSynthesisVoice.speechVoices().map {$0.language}.contains(language)
    }

    func speakSentence(_ sentence: String, language: String) -> SignalProducer<(), SpeakError> {
        let proxy = AVSpeechSynthesizerDelegateProxy(pipe: Signal<(), SpeakError>.pipe())
        synthetizer.delegate = proxy

        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = 0.4

        guard let voice = AVSpeechSynthesisVoice(language: language) else { return SignalProducer(error: .languageUnavaible(language)) }
        
        utterance.voice = voice
        synthetizer.speak(utterance)
        
        return SignalProducer(proxy.signal).on(failed: {[weak self] error in
            self?.isSpeaking.value = false
            }, completed: {[weak self]  in
                self?.isSpeaking.value = false
            }, value: {[weak self] _ in
                self?.isSpeaking.value = true
        })
    }
    



    fileprivate class AVSpeechSynthesizerDelegateProxy: NSObject, AVSpeechSynthesizerDelegate {
        let signal: Signal<(), SpeakError>
        let observer: Observer<(), SpeakError>
        
        @objc fileprivate func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
            observer.send(value: ())
        }
        
        @objc fileprivate func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            observer.sendCompleted()
        }
        
        @objc func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
            observer.send(error: .cancelled)
        }
        
        init(pipe: (output: Signal<(), SpeakError>, input: Observer<(), SpeakError>)) {
            signal = pipe.output
            observer = pipe.input
        }
    }
    
}
