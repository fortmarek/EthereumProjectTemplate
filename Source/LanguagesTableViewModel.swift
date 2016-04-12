//
//  ImagesTableViewModel.swift
//  SampleTestingProject
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveCocoa
import CoreLocation


enum LoadLanguagesError: ErrorType {
    case Request(RequestError)
    case Geocoding(NSError)
}
extension LoadLanguagesError : ErrorPresentable {
    var title: String? { //custom title
        return L10n.LanguageTableNetworkErrorTitle.string
    }
    var message: String { //underlying error description
        switch self {
        case .Request(let e): return e.message
        case .Geocoding(let e): return e.message
        }
    }
}

protocol LanguagesTableViewModeling {
    var cellModels: MutableProperty<[LanguageDetailViewModeling]> { get }
    var loadLanguages: Action<(), [LanguageEntity], LoadLanguagesError> { get }
}

class LanguagesTableViewModel: LanguagesTableViewModeling {

    let cellModels = MutableProperty<[LanguageDetailViewModeling]>([])
    let loading = MutableProperty<Bool>(false)

    //MARK: Dependencies
    private let api: LanguagesAPIServicing
    private let geocoder: Geocoding
    private let locationManager: LocationManager
    private let detailModelFactory: LanguageDetailModelingFactory


    init(api: LanguagesAPIServicing, geocoder: Geocoding, locationManager: LocationManager, detailModelFactory: LanguageDetailModelingFactory) {
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
        
        cellModels <~ loadLanguages.values.map { [unowned self] languages in
            return languages.map { self.detailModelFactory(language: $0) } }
    }


    //MARK: Action
    
    lazy var loadLanguages: Action<(), [LanguageEntity], LoadLanguagesError> = Action { [unowned self] _ in
        return self.api.languages()
            .mapError { .Request($0) }
            .flatMap(.Latest) { languages -> SignalProducer<[LanguageEntity], LoadLanguagesError> in
                //The simulator user location works unexpectably in simulator
                if let userLocation = self.locationManager.location where TARGET_OS_SIMULATOR == 0 {
                    return self.sortLanguageByDistanceFromUserLocation(languages.filter {$0.abbr.characters.first != "_"}, userLocation: userLocation)
                        .mapError { .Geocoding($0) }
                } else {
                    //Continue if we don't have user location
                    return SignalProducer<[LanguageEntity], LoadLanguagesError>(value: languages)
                }
        }
    }
    
    
    private func sortLanguageByDistanceFromUserLocation(languages: [LanguageEntity], userLocation: CLLocation) -> SignalProducer<[LanguageEntity], NSError> {
            //Get geolocation for every language
            let signalProducers: [SignalProducer<(LanguageEntity, CLLocation?), NSError>] = languages.map { language in
                let languageProducer = SignalProducer<LanguageEntity, NSError>(value: language)

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
