//
//  WeatherData.swift
//  WeatherTest
//
//  Created by Pavel N on 11/21/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import Foundation

class WeatherData {
    var currentWeather:CurrentWeather?
    var events:Events = []
    var ditails:WeatherDitails = []
    
    func parseBackendData(_ current:CurrentWeatherData, _ hourly:HourlyWeatherData) {
        let cityName = current.name
        let temperature = Int((current.main?.temp)!)
        let clouds = current.weather?.first?.weatherDescription
        let date = Date(timeIntervalSince1970: Double(current.dt!))
        let timeZone = TimeZone(secondsFromGMT: current.timezone!)
        let temp_min = Int((current.main?.tempMin)!)
        let temp_max = Int((current.main?.tempMax)!)
        self.currentWeather = CurrentWeather(cityName: cityName,
                                             temperature: temperature, clouds: clouds, date: date,
                                             timeZone: timeZone,
                                             temp_min: temp_min, temp_max: temp_max)
        
        events.removeAll()
        let twentyFourHours = Int((currentWeather?.date!.addingTimeInterval(86400).timeIntervalSince1970)!)
        let filtered = hourly.list.filter({ return $0.dt <  twentyFourHours })
        for item in filtered {
            events.append(HourlyEvent(time: Date(timeIntervalSince1970: Double(item.dt)), timeZone: TimeZone(secondsFromGMT: current.timezone!)!, iconName: item.weather.first?.icon, temp: Int(item.main.temp)))
        }
        
        ditails.removeAll()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let sunrise = formatter.string(from: Date(timeIntervalSince1970: Double(current.sys!.sunrise!)))
        let sunset = formatter.string(from: Date(timeIntervalSince1970: Double(current.sys!.sunset!)))
        
        self.ditails.append(WeatherDitail(name: "Atmospheric pressure", value: String(current.main!.pressure!), postfix: "hPa"))
        self.ditails.append(WeatherDitail(name: "Humidity", value: String(current.main!.humidity!), postfix: "%"))
        self.ditails.append(WeatherDitail(name: "Wind speed", value: String((current.wind?.speed)!), postfix: "meter/sec"))
        self.ditails.append(WeatherDitail(name: "Sunrise", value: sunrise, postfix: ""))
        self.ditails.append(WeatherDitail(name: "Sunset", value: sunset, postfix: ""))
    }
}
