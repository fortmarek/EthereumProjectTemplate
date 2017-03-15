//
//  LanguagesAPIService.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveSwift
import ACKReactiveExtensions

protocol LanguagesAPIServicing {
    func languages() -> SignalProducer<[Language], RequestError>
}

class LanguagesAPIService: APIService, LanguagesAPIServicing {
    
    func languages() -> SignalProducer<[Language], RequestError> {
        
        return self.request("languages.json")
            .validateEmptyValue()
            .flatMap(.latest) { json  -> SignalProducer<[Language], RequestError> in
                return rac_decode(object: json as AnyObject).mapError { .mapping(MappingError(underlyingError: $0)) }
        }
    }
}
