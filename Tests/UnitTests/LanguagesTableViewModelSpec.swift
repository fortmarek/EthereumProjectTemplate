//
//  ImagesTableViewSpec.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/28/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import Quick
import Nimble
import ReactiveCocoa
import Alamofire
import Result

@testable import ProjectSkeleton

// Specificatios of LanguagesTableViewModel

class LanguagesTableViewModelSpec: QuickSpec {

    // MARK: Stub
    class GoodStubUnicornApi: LanguagesAPIServicing {
        func languages() -> SignalProducer<[LanguageEntity], RequestError> {
            return SignalProducer<[LanguageEntity], RequestError> { sink, disposable in
                sink.sendNext(dummyResponse)
                sink.sendCompleted()
            }
        }
    }

    class ErrorStubUnicornApi: LanguagesAPIServicing {
        func languages() -> SignalProducer<[LanguageEntity], RequestError> {
            return SignalProducer(error: .Network(NetworkError(error: NSError(domain: "", code: 0, userInfo: nil), request: nil, response: nil)))
                .observeOn(QueueScheduler())
        }
    }

    class StubNetwork: Networking {
        func request(_ url: String, method: Alamofire.Method, parameters: [String: AnyObject]?, encoding: ParameterEncoding, headers: [String: String]?, useDisposables: Bool) -> SignalProducer<AnyObject, NetworkError> {
            return SignalProducer.empty
        }
    }

    class GeocoderStub: Geocoding {
        func locationForCountryAbbreviation(_ abbr: String) -> SignalProducer<CLLocation?, NSError> {
            return SignalProducer<CLLocation?, NSError> { sink, disposable in
                var location: CLLocation? = nil
                if (abbr == "en") {
                    location = CLLocation(latitude: 53.203186, longitude: -1.491233)
                } else if (abbr == "cz") {
                    location = CLLocation(latitude: 50.071277, longitude: 14.496287)
                }

                sink.sendNext(location)
                sink.sendCompleted()
            }
        }
    }

    class ErrorGeocoderStub: Geocoding {
        func locationForCountryAbbreviation(_ abbr: String) -> SignalProducer<CLLocation?, NSError> {
            return SignalProducer<CLLocation?, NSError> { sink, disposable in
                sink.sendNext(nil)
                sink.sendCompleted()
            }
        }
    }

    class LocationManagerStub: LocationManager {
        func startUpdatingLocation() { }
        func requestWhenInUseAuthorization() { }
        var location: CLLocation? = nil
    }

    class SpeechSynthetizerStub: SpeechSynthetizing {
        var isSpeaking: MutableProperty<Bool> { return MutableProperty(false) }
        func canSpeakLanguage(_ language: String) -> Bool { return false }
        func speakSentence(_ sentence: String, language: String) -> SignalProducer<(), SpeakError> { return SignalProducer.empty }
    }

    let detailFactory: LanguageDetailModelingFactory = { language in LanguageDetailViewModel(language: language, synthetizer: SpeechSynthetizerStub()) }

    override func spec() {
        var viewModel: LanguagesTableViewModeling!

        beforeEach {
            viewModel = LanguagesTableViewModel(api: GoodStubUnicornApi(), geocoder: GeocoderStub(), locationManager: LocationManagerStub(), detailModelFactory: self.detailFactory)
        }

        describe("Languages view model") {
            it("eventually sets cellModels after load") {
                var cellModels: [LanguageDetailViewModeling]? = nil
                viewModel.cellModels.producer
                    .on(next: {
                        cellModels = $0
                })
                    .start()

                viewModel.loadLanguages.apply().start()

                expect(cellModels).toEventuallyNot(beNil())
                expect(cellModels?.count).toEventually(equal(2))
                expect(cellModels?[0].name.value).toEventually(equal("English"))
                expect(cellModels?[1].name.value).toEventually(equal("Czech"))
            }

            it("updates loadLanguages.executing property.") {
                var observedValues = [Bool]()
                viewModel.loadLanguages.executing.producer
                    .on(next: { observedValues.append($0) })
                    .start()

                viewModel.loadLanguages.apply().start()

                expect(observedValues).toEventually(equal([false, true, false]))
            }

            context("on network error") {
                it("reports loadLanguages error.") {
                    let viewModel = LanguagesTableViewModel(api: ErrorStubUnicornApi(), geocoder: GeocoderStub(), locationManager: LocationManagerStub(), detailModelFactory: self.detailFactory)
                    var error: LoadLanguagesError? = nil
                    viewModel.loadLanguages.errors.observeNext { error = $0 }
                    viewModel.loadLanguages.apply().start()
                    expect(error).toEventuallyNot(beNil())
                }
            }

            context("when user location is turned off") {

                it("does not load geocoding") {
                    class GeocoderMock: Geocoding {
                        var loaded = false
                        func locationForCountryAbbreviation(_ abbr: String) -> SignalProducer<CLLocation?, NSError> {
                            self.loaded = true
                            return SignalProducer.empty
                        }
                    }
                    let geocoder = GeocoderMock()

                    let viewModel = LanguagesTableViewModel(api: GoodStubUnicornApi(), geocoder: geocoder, locationManager: LocationManagerStub(), detailModelFactory: self.detailFactory)

                    viewModel.loadLanguages.apply().start()

                    expect(geocoder.loaded).toEventuallyNot(beTrue())

                }
            }

            context("when user location is turned on") {

                let locationManager = LocationManagerStub()
                locationManager.location = CLLocation(latitude: 53.907160, longitude: -1.233959) // <-- England

                it("does sort languages by distance to user location") {
                    let viewModel = LanguagesTableViewModel(api: GoodStubUnicornApi(), geocoder: GeocoderStub(), locationManager: locationManager, detailModelFactory: self.detailFactory)

                    viewModel.loadLanguages.apply().start()

                    expect(viewModel.cellModels.value.map { $0.name.value }).toEventually(beginWith("English"))
                }

                it("does not fail on geocoding error") {
                    let viewModel = LanguagesTableViewModel(api: GoodStubUnicornApi(), geocoder: ErrorGeocoderStub(), locationManager: locationManager, detailModelFactory: self.detailFactory)

                    viewModel.loadLanguages.apply().start()

                    expect(viewModel.cellModels.value).toEventuallyNot(beNil())
                }
            }

            itBehavesLike("object without leaks") {
                MemoryLeakContext {
                    let viewModel = LanguagesTableViewModel(api: GoodStubUnicornApi(), geocoder: ErrorGeocoderStub(), locationManager: LocationManagerStub(), detailModelFactory: self.detailFactory)
                    viewModel.loadLanguages.apply().start()

                    return viewModel
                }
            }

            it("persists its loadLanguages property") {
                var executing: [Bool] = []
                viewModel.loadLanguages.executing.producer
                    .startWithNext {
                        executing.append($0)
                }
                viewModel.loadLanguages.apply().start()
                expect(executing).toEventually(equal([false, true, false]))
            }
        }
    }
}
