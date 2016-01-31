//
//  SpeechSynthetizer.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import AVFoundation
import ReactiveCocoa

protocol SpeechSynthetizing{
    var isSpeaking:MutableProperty<Bool>{ get }
    func canSpeakLanguage(language:String) -> Bool
    func speakSentence(sentence:String, language:String) -> SignalProducer<(), NSError>
}

class SpeechSynthetizer:NSObject, SpeechSynthetizing, AVSpeechSynthesizerDelegate{
    let synthetizer:AVSpeechSynthesizer
    
    override init(){
        self.synthetizer = AVSpeechSynthesizer()
        super.init()
    }
    
    var isSpeaking = MutableProperty<Bool>(false)
    
    func canSpeakLanguage(language:String) -> Bool{
        
        return AVSpeechSynthesisVoice.speechVoices().map{$0.language}.contains(language)
    }
    
    func speakSentence(sentence:String, language:String) -> SignalProducer<(), NSError>{
        let proxy = AVSpeechSynthesizerDelegateProxy(pipe: Signal<(), NSError>.pipe())
        synthetizer.delegate = proxy
        
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.rate = 0.4
    
        if let voice = AVSpeechSynthesisVoice(language: language){
            utterance.voice = voice
            synthetizer.speakUtterance(utterance)
            
            return SignalProducer(signal: proxy.signal).on(next:{[weak self] _ in
                self?.isSpeaking.value = true
                }, failed:{[weak self] error in
                    self?.isSpeaking.value = false
                }, completed:{[weak self]  in
                    self?.isSpeaking.value = false
                })
        }
        
        
        return SignalProducer<(), NSError>{ sink, disposable in
            //TODO: Better errors
            sink.sendFailed(NSError(domain: "SpeechSynthesizer", code: 0, userInfo: nil))
        }
        
    }
    
    
    private class AVSpeechSynthesizerDelegateProxy: NSObject, AVSpeechSynthesizerDelegate {
        let signal: Signal<(), NSError>
        let observer: Observer<(), NSError>
        
        @objc private func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance) {
            observer.sendNext()
        }
        
        @objc private func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
            observer.sendCompleted()
        }
        
        @objc func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didCancelSpeechUtterance utterance: AVSpeechUtterance) {
            observer.sendFailed((NSError(domain: "AVSpeechSynthesizer", code: 0, userInfo: nil)))
        }
        
        init(pipe: (signal: Signal<(), NSError>, observer: Observer<(), NSError>)) {
            signal = pipe.signal
            observer = pipe.observer
        }
    }
    
    
}

