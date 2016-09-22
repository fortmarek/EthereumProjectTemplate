//
//  Geocoder.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/29/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//
import ReactiveCocoa
import AddressBook

class Geocoder: Geocoding {
    let geocoder: CLGeocoder

    init() {
        self.geocoder = CLGeocoder()
    }

    func locationForCountryAbbreviation(abbr: String) -> SignalProducer<CLLocation?, NSError> {

        return SignalProducer<CLLocation?, NSError> { sink, disposable in

            let checkAddress: [NSObject:AnyObject] = [
                kABPersonAddressCountryKey:abbr
            ]


            self.geocoder.geocodeAddressDictionary(checkAddress) { (placemarks: [CLPlacemark]?, error) -> Void in
                sink.sendNext(placemarks?.first?.location)
                sink.sendCompleted()
            }
        }
    }
}
