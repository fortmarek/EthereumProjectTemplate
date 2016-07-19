//
//  LanguagesAPIService.swift
//  GrenkePlayground
//
//  Created by Tomas Kohout on 4/12/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa

class LanguagesAPIService: APIService, LanguagesAPIServicing {

    func languages() -> SignalProducer<[LanguageEntity], RequestError> {
        return self.request("languages.json")
            .mapError { .Network($0) }
            .flatMap(.Latest) { json in
                rac_decode(json)
                    .mapError { .Mapping($0) }
        }
    }
}
