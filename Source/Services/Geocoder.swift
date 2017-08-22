//
//  Geocoder.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/29/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import ReactiveSwift
import AddressBook
import Contacts
import CoreLocation

class Geocoder: Geocoding {
    let geocoder: CLGeocoder

    init() {
        self.geocoder = CLGeocoder()
    }

    func locationForCountryAbbreviation(_ abbr: String) -> SignalProducer<CLLocation?, NSError> {

        return SignalProducer<CLLocation?, NSError> { sink, disposable in

            let checkAddress: [AnyHashable: Any] = [
                CNPostalAddressCountryKey: abbr
            ]


            self.geocoder.geocodeAddressDictionary(checkAddress) { (placemarks: [CLPlacemark]?, error) -> Void in
                sink.send(value: placemarks?.first?.location)
                sink.sendCompleted()
            }
        }
    }
}
