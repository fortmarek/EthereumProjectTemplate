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

class LanguagesAPIService: APIService, LanguagesAPIServicing {
    init(network: Networking) {
        super.init(network: network, authHandler: nil)
    }
    
    func languages() -> SignalProducer<[LanguageEntity], RequestError> {
        return self.request("languages.json")
            .mapError { .network($0) }
            .flatMap(.latest) { json in
                rac_decode(object: json as AnyObject).mapError { .mapping($0) }
        }
    }
}
