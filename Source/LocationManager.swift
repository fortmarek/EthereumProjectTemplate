//
//  LocationManager.swift
//  ProjectSkeleton
//
//  Created by Tomas Kohout on 1/30/16.
//  Copyright © 2016 Ackee s.r.o. All rights reserved.
//

import CoreLocation

protocol LocationManager {
    func startUpdatingLocation()
    func requestWhenInUseAuthorization()
    var location: CLLocation? { get }
}

extension CLLocationManager:LocationManager {

}
