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
        let cityName = current.name ?? "Unknown"
        let temperature = Int((current.main?.temp)! - 273.15)
        let clouds = current.weather?.first?.weatherDescription ?? "Unknown"
        let date = Date(timeIntervalSince1970: Double(current.dt ?? 0))
        let timeZone = TimeZone(secondsFromGMT: current.timezone ?? 0) ?? TimeZone.current
        let temp_min = Int((current.main?.tempMin ?? 0) - 273.15)
        let temp_max = Int((current.main?.tempMax ?? 0) - 273.15)
        self.currentWeather = CurrentWeather(cityName: cityName,
                                             temperature: temperature, clouds: clouds, date: date,
                                             timeZone: timeZone,
                                             temp_min: temp_min, temp_max: temp_max)
        //3h weather
        events.removeAll()
        let twentyFourHours = Int(date.addingTimeInterval(86400).timeIntervalSince1970)
        let filtered = hourly.list.filter({ return $0.dt <  twentyFourHours })
        for item in filtered {
            events.append(HourlyEvent(time: Date(timeIntervalSince1970: Double(item.dt)), timeZone: TimeZone(secondsFromGMT: current.timezone ?? 0) ?? TimeZone.current, iconName: item.weather.first?.icon ?? "", temp: Int(item.main.temp  - 273.15)))
        }
        
        //Ditails table
        ditails.removeAll()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let sunrise = formatter.string(from: Date(timeIntervalSince1970: Double(current.sys?.sunrise ?? -1)))
        let sunset = formatter.string(from: Date(timeIntervalSince1970: Double(current.sys?.sunset ?? -1)))
        
        self.ditails.append(WeatherDitail(name: "Atmospheric pressure", value: String(current.main?.pressure ?? -1), postfix: "hPa"))
        self.ditails.append(WeatherDitail(name: "Humidity", value: String(current.main?.humidity ?? -1), postfix: "%"))
        self.ditails.append(WeatherDitail(name: "Wind speed", value: String(current.wind?.speed ?? -1), postfix: "meter/sec"))
        self.ditails.append(WeatherDitail(name: "Sunrise", value: sunrise, postfix: ""))
        self.ditails.append(WeatherDitail(name: "Sunset", value: sunset, postfix: ""))
        
        //days
        daysOverview.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        var avalibleDays:[String:[ListHourly]] = [:]
        var arrayOfWeekDays:[String] = []
        for item in hourly.list {
            let date = Date(timeIntervalSince1970:Double(item.dt))
            let dayStr = String (dateFormatter.string(from: date ).capitalized)
            
            if avalibleDays[dayStr] != nil {
                avalibleDays[dayStr]!.append(item)
            } else {
                arrayOfWeekDays.append(dayStr)
                avalibleDays[dayStr] = [item]
            }
        }
        avalibleDays.removeValue(forKey: String (dateFormatter.string(from: Date()).capitalized))
        
        for key in arrayOfWeekDays {
            guard let values = avalibleDays[key] else { continue }
            let maxValue = (values.compactMap({ $0.main.tempMax }).max() ?? -1) - 273.15
            let minValue = (values.compactMap({ $0.main.tempMin }).min() ?? -1) - 273.15
            let midDayIndex = Int(values.count/2)
            let midDayValue = values[midDayIndex].weather.first?.icon ?? ""
            daysOverview.append(DayOverview(nameOfDay: key, minTemp: Int(minValue), maxTemp: Int(maxValue), iconName: midDayValue ))
        }
        print(daysOverview)
        
    }
}
