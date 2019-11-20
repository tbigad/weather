//
//  LocationHelper.swift
//  Weather
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationHelperDelegate {
    func locationupdated(latitude:Double,longitude:Double)
}

class LocationHelper : NSObject {
    var delegate:LocationHelperDelegate?
    
    private let locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers

        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            getLocation()
        }
    }
    
    private func getLocation(){
        locationManager.requestLocation()
    }

}

extension LocationHelper : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.delegate?.locationupdated(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
