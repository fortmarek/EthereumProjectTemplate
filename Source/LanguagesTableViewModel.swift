//
//  ImagesTableViewModel.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa
import CoreLocation

protocol LanguagesTableViewModeling {
    var cellModels: MutableProperty<[LanguageDetailViewModeling]> { get }
    var loading: MutableProperty<Bool> { get }
    var errorMessage: MutableProperty<String?> { get }
    var loadLanguages: Action<(), [LanguageEntity], NSError> { get }

}

class LanguagesTableViewModel: LanguagesTableViewModeling {

    var cellModels = MutableProperty<[LanguageDetailViewModeling]>([])
    var loading = MutableProperty<Bool>(false)
    var errorMessage = MutableProperty<String?>(nil)

    //MARK: Dependencies
    private let api: API
    private let geocoder: Geocoding
    private let locationManager: LocationManager
    private let detailModelFactory: LanguageDetailModelingFactory


    init(api: API, geocoder: Geocoding, locationManager: LocationManager, detailModelFactory: LanguageDetailModelingFactory) {
        self.api = api
        self.geocoder = geocoder
        self.locationManager = locationManager
        self.detailModelFactory = detailModelFactory

        self.setupBindings()
    }

    func setupBindings() {
        //Uncomment to test the memory leak test
//        self.loading.producer.startWithNext { _ in
//            let api = self.api
//
//        }
    }


    //MARK: Action

    private var canLoadImages: AnyProperty<Bool> {
        return AnyProperty(
            initialValue: true,
            producer: loading.producer.map {!$0})
    }

    lazy var loadLanguages: Action<(), [LanguageEntity], NSError> = {
        return Action(enabledIf: self.canLoadImages) { [unowned self] _ in
            self.loading.value = true
            
            return self.api.languages().flatMap(.Latest) { languages -> SignalProducer<[LanguageEntity], NSError> in
                if let userLocation = self.locationManager.location {
                    return self.sortLanguageByDistanceFromUserLocation(languages.filter {$0.abbr.characters.first != "_"}, userLocation: userLocation)
                } else {
                    //Continue if we don't have user location
                    return SignalProducer<[LanguageEntity], NSError> {sink, disposable in
                        sink.sendNext(languages)
                        sink.sendCompleted()
                    }
                }
                }.on(
                    next: { languages in
                        self.cellModels.value = languages.map { self.detailModelFactory(language: $0)}
                        self.loading.value = false
                    },
                    failed: { error in
                        self.loading.value = false
                        self.errorMessage.value = L10n.LanguageTableNetworkErrorMessage.string
                })
        }
        }()

    
    private func sortLanguageByDistanceFromUserLocation(languages: [LanguageEntity], userLocation: CLLocation) -> SignalProducer<[LanguageEntity], NSError> {
            //Get geolocation for every language
            let signalProducers: [SignalProducer<(LanguageEntity, CLLocation?), NSError>] = languages.map { language in
                let languageProducer = SignalProducer<LanguageEntity, NSError> { sink, disposable in
                    sink.sendNext(language)
                    sink.sendCompleted()
                }

                return combineLatest(languageProducer, self.geocoder.locationForCountryAbbreviation(language.abbr))
            }

            //Check all geolocations in sequence
            return SignalProducer(values: signalProducers).flatten (.Concat).reduce([], { (var array: [(LanguageEntity, CLLocation?)], item: (LanguageEntity, CLLocation?))  in
                    array.append(item)
                    return array

            //Sort by closest
            }).map { languages in
                languages.sort({ entityA, entityB in
                    let (_, locationA) = entityA; let (_, locationB) = entityB
                    return locationA?.distanceFromLocation(userLocation) < locationB?.distanceFromLocation(userLocation)
                }).map {$0.0}
            }
    }



}
