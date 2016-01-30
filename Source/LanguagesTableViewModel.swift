//
//  ImagesTableViewModel.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa
import CoreLocation
import Swinject

class LanguagesTableViewModel: LanguagesTableViewModeling {
    
    var cellModels = MutableProperty<[LanguageDetailModeling]>([])
    var loading = MutableProperty<Bool>(false)
    var errorMessage = MutableProperty<String?>(nil)
    
    
    
    private var languages: [(language:LanguageEntity, location:CLLocation?)]
    
    //MARK: Action
    
    private var canLoadImages: AnyProperty<Bool> {
        return AnyProperty(
            initialValue: true,
            producer: loading.producer.map{!$0})
    }
    
    var loadLanguages: Action<(), (LanguageEntity, CLLocation?), NSError> {
        return Action(enabledIf: canLoadImages) { _ in
            self.loading.value = true
            
            
            return self.api.languages().flatMap(.Latest) { (languages:[LanguageEntity]) -> SignalProducer<(LanguageEntity, CLLocation?), NSError> in
                
                
                
                /*SignalProducer(values: languages.map{ language in
                return SignalProducer<LanguageEntity, NSError>{ sink, disposable in
                sink.sendNext(language)
                sink.sendCompleted()
                }
                
                }).flatten (.Merge).startWithNext({ language in
                print(language)
                })*/
                
                
                
                let signalProducers:[SignalProducer<(LanguageEntity, CLLocation?), NSError>] = languages.filter{
                    print($0.abbr.characters.first)
                    return $0.abbr.characters.first != "_"}.map{ language in
                    print(language)
                    
                    let l = SignalProducer<LanguageEntity, NSError>{ sink, disposable in
                        sink.sendNext(language)
                        sink.sendCompleted()
                    }
                    
                    let g = self.geocoder.locationForCountryAbbreviation(language.abbr)
                    
                    return combineLatest(l, g)
                }
                
                return SignalProducer(values: signalProducers).flatten (.Concat)
                
                }.on(
                    next:{ language, location in
                        self.languages.append((language, location))
                    },
                    completed:{
                        
                        
                        if let myLocation = self.locationManager.location {
                            
                             self.languages.sortInPlace({ entityA, entityB in
                                entityA.location?.distanceFromLocation(myLocation) < entityB.location?.distanceFromLocation(myLocation)
                            })
                            
                            
                            
                        }
                        
                        self.cellModels.value = self.languages.map{ self.detailModelFactory(language: $0.language)}
                        
                        self.loading.value = false
                    },
                    failed:{ error in
                        self.errorMessage.value = "Something happened"
                    }
            )
            
        }
    }
    
    
    //MARK: Dependencies
    private let api: API
    private let geocoder: Geocoding
    private let locationManager: LocationManager
    private let detailModelFactory: LanguageDetailModelingFactory
    
    init(api: API, geocoder: Geocoding, locationManager: LocationManager, detailModelFactory: LanguageDetailModelingFactory) {
        self.api = api
        self.geocoder = geocoder
        self.languages = []
        self.locationManager = locationManager
        self.detailModelFactory = detailModelFactory
    }
}