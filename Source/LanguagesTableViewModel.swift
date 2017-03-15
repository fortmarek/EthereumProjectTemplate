//
//  LanguagesTableViewModel.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/25/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import ReactiveSwift
import CoreLocation


enum LoadLanguagesError: Error {
    case request(RequestError)
    case geocoding(NSError)
}
extension LoadLanguagesError : ErrorPresentable {
    var title: String? { //custom title
        return L10n.Languagetable.networkErrorTitle
    }
    var message: String { //underlying error description
        switch self {
        case .request(let e): return e.message
        case .geocoding(let e): return e.message
        }
    }
}

protocol LanguagesTableViewModeling {
    var cellModels: MutableProperty<[LanguageDetailViewModeling]> { get }
    var loadLanguages: Action<(), [Language], LoadLanguagesError> { get }
}

class LanguagesTableViewModel: LanguagesTableViewModeling {
    
    let cellModels = MutableProperty<[LanguageDetailViewModeling]>([])
    let loading = MutableProperty<Bool>(false)
    
    //MARK: Dependencies
    fileprivate let api: LanguagesAPIServicing
    fileprivate let geocoder: Geocoding
    fileprivate let locationManager: LocationManager
    fileprivate let detailModelFactory: LanguageDetailModelingFactory
    
    
    required init(api: LanguagesAPIServicing, geocoder: Geocoding, locationManager: LocationManager, detailModelFactory: @escaping LanguageDetailModelingFactory) {
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
            return languages.map { self.detailModelFactory($0) } }
    }
    
    
    //MARK: Action
    
    lazy var loadLanguages: Action<(), [Language], LoadLanguagesError> = Action { [unowned self] _ in
        return self.api.languages()
            .mapError { .request($0) }
            .flatMap(.latest) { languages -> SignalProducer<[Language], LoadLanguagesError> in
                //The simulator user location works unexpectably in simulator
                if let userLocation = self.locationManager.location , TARGET_OS_SIMULATOR == 0 {
                    return self.sortLanguageByDistanceFromUserLocation(languages.filter {$0.abbr.characters.first != "_"}, userLocation: userLocation).mapError { .geocoding($0) }
                } else {
                    //Continue if we don't have user location
                    return SignalProducer<[Language], LoadLanguagesError>(value: languages)
                }
        }
    }
    
    
    fileprivate func sortLanguageByDistanceFromUserLocation(_ languages: [Language], userLocation: CLLocation) -> SignalProducer<[Language], NSError> {
        //Get geolocation for every language
        let signalProducers: [SignalProducer<(Language, CLLocation?), NSError>] = languages.map { language in
            let languageProducer = SignalProducer<Language, NSError>(value: language)
            
            return SignalProducer.combineLatest(languageProducer, self.geocoder.locationForCountryAbbreviation(language.abbr))
        }
        
        //Check all geolocations in sequence
        let geolocations = SignalProducer<SignalProducer<(Language, CLLocation?), NSError>, NSError>(signalProducers)
            .flatten(.concat)
            .reduce([], { (array: [(Language, CLLocation?)], item: (Language, CLLocation?)) -> [(Language, CLLocation?)] in
                var array = array
                array.append(item)
                return array
            })
        
        //Sort by closest
        return geolocations.map { languages -> [Language] in
            languages.sorted(by: { entityA, entityB in
                let (_, locationA) = entityA; let (_, locationB) = entityB
                return locationA?.distance(from: userLocation) ?? 0 < locationB?.distance(from: userLocation) ?? 0
            }).map { $0.0}
        }
    }
    
    
    
}
