//
//  CurrentWeatherBackendOperation.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import Foundation

enum LoginBackendOperationResult {
    case error(String)
    case succes(data:CurrentWeatherData)
}

class CurrentWeatherBackendOperation: BaseBackendOperation {
    public var result:LoginBackendOperationResult?;
    fileprivate var lon:Double?
    fileprivate var lat:Double?
    init(_ longitude: Double,_ latitude: Double) {
        self.lon = longitude;
        self.lat = latitude;
    }
    
    override func main() {
        logIn()
    }
    
    private func logIn(){
        let serviceURL = "https://api.openweathermap.org/data/2.5/weather"
        guard let lon = self.lon, let lat = self.lat else {
            result = .error("")
            fail()
            return
        }
        
        var components = URLComponents(string: serviceURL)
        components?.queryItems = [
            URLQueryItem(name: "appid", value: "9f13516c6cf460a1d23b219882960e49"),
            URLQueryItem(name: "lat", value: String(lat) ),
            URLQueryItem(name: "lon", value: String(lon) )
        ]
        guard let url = URL(string: (components?.url!.absoluteString)!) else {
            fail()
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                self.result = .error(error.localizedDescription)
                self.fail()
            }
            guard let data = data else {return;}
            
            let decodeResult: (decodableObj: CurrentWeatherData?, error: Error?) = CodableHelper.decode(CurrentWeatherData.self, from: data)
            
            guard let weatherData = decodeResult.decodableObj else { return; }
            self.result = .succes(data: weatherData)
            self.succes()
        }
        task.resume()
    }
}
