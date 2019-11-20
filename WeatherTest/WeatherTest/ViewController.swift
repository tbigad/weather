//
//  ViewController.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let locationHelper = LocationHelper()
    
    private var commonQueue:OperationQueue?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper.delegate = self
        // Do any additional setup after loading the view.
    }

    func updateBackendData(_ lat:Double, _ lon:Double) {
        commonQueue = OperationQueue()
        let operation = GetWeatherAsyncOperation(lon: lon, lat: lat)
        commonQueue?.addOperation(operation)
    }
}

extension ViewController:LocationHelperDelegate{
    func locationupdated(latitude: Double, longitude: Double) {
        updateBackendData(latitude, longitude)
    }
}

