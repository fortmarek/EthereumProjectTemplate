//
//  ImagesTableViewSpec.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/28/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import Quick
import Nimble
import ReactiveCocoa

@testable import SampleTestingProject

/// Specificatios of ImageTableViewModel
class LanguagesTableViewModelSpec: QuickSpec {
    
    // MARK: Stub
    class GoodStubUnicornApi: API {
        func languages() -> SignalProducer<[LanguageEntity], NSError> {
            return SignalProducer<[LanguageEntity], NSError>{sink, disposable in
                sink.sendNext(dummyResponse)
                sink.sendCompleted()
            }
        }
    }
    
    class ErrorStubUnicornApi: API {
        func languages() -> SignalProducer<[LanguageEntity], NSError> {
            return SignalProducer { observer, disposable in
                observer.sendFailed(NSError(domain: "", code: 0, userInfo: nil))
                }
                .observeOn(QueueScheduler())
        }
    }
    
    class StubNetwork: Networking {
        func call<T>(route: APIRouter, authHandler: AuthHandler?, useDisposables: Bool, action: (AnyObject -> (SignalProducer<T, NSError>))) -> SignalProducer<T, NSError> {
            return SignalProducer.empty
        }
    }
    
    class GeocoderStub: Geocoding {
        func locationForCountryAbbreviation(abbr: String) -> SignalProducer<CLLocation?, NSError>{
            return SignalProducer<CLLocation?, NSError>{sink, disposable in
                var location: CLLocation? = nil
                if (abbr == "en"){
                    location = CLLocation(latitude: 53.203186, longitude: -1.491233)
                }else if (abbr == "cz"){
                    location = CLLocation(latitude: 50.071277, longitude: 14.496287)
                }
                    
                sink.sendNext(location)
                sink.sendCompleted()
            }
        }
    }
    
    class LocationManagerStub: LocationManager{
        func startUpdatingLocation(){}
        func requestWhenInUseAuthorization(){}
        var location: CLLocation? = nil
    }
    
    class LanguageDetailViewModelStub: LanguageDetailViewModeling{
        var name: MutableProperty<String> { return MutableProperty("") }
        var sentence: MutableProperty<String> { return MutableProperty("") }
        var flagURL : MutableProperty<NSURL> { return MutableProperty(NSURL(string: "")!) }
        var canPlaySentence: MutableProperty<Bool> { return MutableProperty(false) }
        var isSpeaking: MutableProperty<Bool> { return MutableProperty(false) }
        var playSentence: Action<UIButton, (), NSError> {return Action{_ in return SignalProducer.empty}}
    }
    
    let LanguageDetailModelingFactoryStub:LanguageDetailModelingFactory  = { _ in LanguageDetailViewModelStub()}
    
    
    override func spec() {
        var viewModel: LanguagesTableViewModeling!
        
        
        beforeEach {
            viewModel = LanguagesTableViewModel(api: GoodStubUnicornApi(), geocoder: GeocoderStub(), locationManager: LocationManagerStub(), detailModelFactory: self.LanguageDetailModelingFactoryStub)
        }
        
        describe("Image load") {
            it("eventually sets cellModels after load") {
                var cellModels: [LanguageDetailViewModeling]? = nil
                viewModel.cellModels.producer
                    .on(next: { cellModels = $0 })
                    .start()
                
                viewModel.loadLanguages.apply().start()
                
                expect(cellModels).toEventuallyNot(beNil())
                expect(cellModels?.count).toEventually(equal(2))
                expect(cellModels?[0].name.value).toEventually(equal("English"))
                expect(cellModels?[1].name.value).toEventually(equal("Czech"))
            }
            
            it("updates loading property ") {
                var observedValues = [Bool]()
                viewModel.loading.producer
                    .on(next: { observedValues.append($0) })
                    .start()
                
                viewModel.loadLanguages.apply().start()
                
                expect(observedValues).toEventually(equal([false, true, false]))
            }
            
            
            context("on error") {
                it("sets errorMessage property.") {
                    let viewModel = LanguagesTableViewModel(api: ErrorStubUnicornApi(), geocoder: GeocoderStub(), locationManager: LocationManagerStub(), detailModelFactory: self.LanguageDetailModelingFactoryStub)
                    viewModel.loadLanguages.apply().start()
                    expect(viewModel.errorMessage.value).toEventuallyNot(beNil())
                }
            }
        }
    }
}
