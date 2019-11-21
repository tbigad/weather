//
//  CurrentWeather.swift
//  WeatherTest
//
//  Created by Pavel N on 11/20/19.
//  Copyright © 2019 Pavel N. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let cityName:String?
    let temperature:Int?
    let clouds:String?
    let date:Date?
    let timeZone:TimeZone?
    let temp_min:Int?
    let temp_max:Int?
}


struct HourlyEvent {
    let time:Date
    let timeZone:TimeZone
    let iconName:String?
    let temp:Int
}

struct WeatherDitail {
    let name:String?
    let value:String?
    let postfix:String?
}

typealias WeatherDitails = [WeatherDitail]
typealias Events = [HourlyEvent]
