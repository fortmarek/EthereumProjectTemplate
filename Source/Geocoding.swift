//
//  Geocoding.swift
//  GrenkePlayground
//
//  Created by Tomas Kohout on 1/29/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import ReactiveCocoa

protocol Geocoding {
    func locationForCountryAbbreviation(abbr: String) -> SignalProducer<CLLocation?, NSError>
}
