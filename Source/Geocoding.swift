//
//  Geocoding.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/29/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import ReactiveSwift
import CoreLocation

protocol Geocoding {
    func locationForCountryAbbreviation(_ abbr: String) -> SignalProducer<CLLocation?, NSError>
}
