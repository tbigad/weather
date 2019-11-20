//
//  HourlyForecastOperation.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import Foundation

enum GetWeatherAsyncOperationResult{
    case succes
    case failed(errorString:String)
}

class GetWeatherAsyncOperation: AsyncOperation {
    var result:GetWeatherAsyncOperationResult?
    private var currentWeatherBackendOperation:CurrentWeatherBackendOperation?
    private var hourlyForecastBackendOperation:HourlyForecastBackendOperation?
    private var backendOperation:OperationQueue?
    fileprivate var lon:Double?
    fileprivate var lat:Double?
    
    init(lon:Double, lat:Double) {
        super.init()
        self.lon = lon
        self.lat = lat
    }
    override func main() {
        getWeatherData()
    }
    
    func getWeatherData() {
        //TODO: add guard
        self.backendOperation = OperationQueue()
        currentWeatherBackendOperation = CurrentWeatherBackendOperation(lon!,lat!)
        hourlyForecastBackendOperation = HourlyForecastBackendOperation(lon!,lat!)
        
        addDependency(currentWeatherBackendOperation!)
        addDependency(hourlyForecastBackendOperation!)
        hourlyForecastBackendOperation!.completionBlock = {
            [weak self, weak hourlyForecastBackendOperation] in
                switch hourlyForecastBackendOperation!.result! {
                case .error(let str):
                    self?.result = .failed(errorString: str)
                case .succes(let data):
                    let d = data
                @unknown default:
                    break
            }
        }
        
        currentWeatherBackendOperation!.completionBlock = {
            [weak self, weak currentWeatherBackendOperation] in
            switch currentWeatherBackendOperation!.result! {
                case .error(let str):
                    self?.result = .failed(errorString: str)
                case .succes(let data):
                    let d = data
                @unknown default:
                    break
            }
        }
        
        backendOperation!.addOperations([hourlyForecastBackendOperation!, currentWeatherBackendOperation!], waitUntilFinished: true)
    }
}
