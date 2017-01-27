import Quick
import Nimble
import ReactiveCocoa

@testable import ProjectSkeleton

class LanguageDetailViewModelSpec: QuickSpec {

    class GoodSpeechSynthetizerStub: SpeechSynthetizing {
        var isSpeaking = MutableProperty<Bool>(false)
        func canSpeakLanguage(_ language: String) -> Bool {
            if (language == "en-EN") {
                return true
            }

            return false
        }
        func speakSentence(_ sentence: String, language: String) -> SignalProducer<(), SpeakError> {
            speaked = true
            return SignalProducer(value: ()).delay(3, onScheduler: QueueScheduler())
        }

        // Stubbed
        var speaked = false
    }

    class BadSpeechSynthetizerStub: SpeechSynthetizing {
        var isSpeaking = MutableProperty<Bool>(false)
        func canSpeakLanguage(_ language: String) -> Bool {
            return true
        }

        func speakSentence(_ sentence: String, language: String) -> SignalProducer<(), SpeakError> {
            return SignalProducer(error: .Cancelled)
        }
    }

    override func spec() {
        var viewModel: LanguageDetailViewModeling!
        var languageEntity: LanguageEntity!
        var synthetizer: GoodSpeechSynthetizerStub!

        describe("Language detail view model") {

            beforeEach {
                languageEntity = dummyResponse[0]
                synthetizer = GoodSpeechSynthetizerStub()
                viewModel = LanguageDetailViewModel(language: languageEntity, synthetizer: synthetizer)
            }

            it("sets all properties") {
                expect(viewModel.name.value).toEventually(equal(languageEntity.name))
                expect(viewModel.flagURL.value.URLString).toEventually(equal(languageEntity.flag))
                expect(viewModel.sentence.value).toEventually(equal(languageEntity.sentence))
            }

            it ("plays the sentence") {
                viewModel.playSentence.apply(UIButton()).start()
                expect(synthetizer.speaked).toEventually(beTrue())
            }

            context("when language code is nil") {
                beforeEach {
                    languageEntity.language_code = nil
                    viewModel = LanguageDetailViewModel(language: languageEntity, synthetizer: synthetizer)
                }
                it ("does not allow to play sentence") {
                    expect(viewModel.playSentence.enabled.value).toEventuallyNot(beTrue())
                    viewModel.playSentence.apply(UIButton()).start()
                    expect(synthetizer.speaked).toEventuallyNot(beTrue())
                }
            }

            context("when the synthetizer is speaking") {

                it ("does not allow to play another sentence") {
                    synthetizer.isSpeaking.value = true

                    expect(viewModel.playSentence.enabled.value).toEventuallyNot(beTrue())

                    synthetizer.isSpeaking.value = false
                    expect(viewModel.playSentence.enabled.value).toEventually(beTrue())
                }
            }

            context("when language is not supported by synthetizer") {
                beforeEach {
                    languageEntity.language_code = nil
                    languageEntity.language_code = "sw-SW" // Swaziland
                    viewModel = LanguageDetailViewModel(language: languageEntity, synthetizer: synthetizer)
                }

                it ("does not allow to play sentence") {
                    expect(viewModel.playSentence.enabled.value).toEventuallyNot(beTrue())
                    viewModel.playSentence.apply(UIButton()).start()
                    expect(synthetizer.speaked).toEventuallyNot(beTrue())
                }
            }

            context("when synthetizer fails") {
                beforeEach {
                    viewModel = LanguageDetailViewModel(language: languageEntity, synthetizer: BadSpeechSynthetizerStub())
                }

                it ("allows to play again") {
                    viewModel.playSentence.apply(UIButton()).start()

                    expect(viewModel.playSentence.enabled.value).toEventually(beTrue())
                }
            }

            itBehavesLike("object without leaks") {
                MemoryLeakContext {
                    LanguageDetailViewModel(language: languageEntity, synthetizer: GoodSpeechSynthetizerStub())
                }
            }
        }

    }
}

