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
    var daysOverview:DaysOverview = []
    
    func parseBackendData(_ current:CurrentWeatherData, _ hourly:HourlyWeatherData) {
        //header weather
        let cityName = current.name
        let temperature = Int((current.main?.temp)! - 273.15)
        let clouds = current.weather?.first?.weatherDescription
        let date = Date(timeIntervalSince1970: Double(current.dt!))
        let timeZone = TimeZone(secondsFromGMT: current.timezone!)
        let temp_min = Int((current.main?.tempMin)! - 273.15)
        let temp_max = Int((current.main?.tempMax)! - 273.15)
        self.currentWeather = CurrentWeather(cityName: cityName,
                                             temperature: temperature, clouds: clouds, date: date,
                                             timeZone: timeZone,
                                             temp_min: temp_min, temp_max: temp_max)
        //3h weather
        events.removeAll()
        let twentyFourHours = Int((currentWeather?.date!.addingTimeInterval(86400).timeIntervalSince1970)!)
        let filtered = hourly.list.filter({ return $0.dt <  twentyFourHours })
        for item in filtered {
            events.append(HourlyEvent(time: Date(timeIntervalSince1970: Double(item.dt)), timeZone: TimeZone(secondsFromGMT: current.timezone!)!, iconName: item.weather.first?.icon, temp: Int(item.main.temp  - 273.15)))
        }
        
        //Ditails table
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
        
        //days
        daysOverview.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        var avalibleDays:[String:[ListHourly]] = [:]
        for item in hourly.list {
            let date = Date(timeIntervalSince1970:Double(item.dt))
            let dayStr = String (dateFormatter.string(from: date ).capitalized)
            
            if avalibleDays[dayStr] != nil {
                avalibleDays[dayStr]!.append(item)
            } else {
                avalibleDays[dayStr] = [item]
            }
        }
        avalibleDays.removeValue(forKey: String (dateFormatter.string(from: Date()).capitalized))
        
        let keys = avalibleDays.keys
        for key in keys {
            let values = avalibleDays[key]
            let maxValue = ((values?.compactMap({ $0.main.tempMax }).max()!)!) - 273.15
            let minValue = (values?.compactMap({ $0.main.tempMin }).min())! - 273.15
            let midDayIndex = Int(values!.count/2)
            let midDayValue = values![midDayIndex].weather.first?.icon
            daysOverview.append(DayOverview(nameOfDay: key, minTemp: Int(minValue), maxTemp: Int(maxValue), iconName: midDayValue! ))
        }
        print(daysOverview)
        
    }
}
