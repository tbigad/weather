// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hourlyWeatherData = try? newJSONDecoder().decode(HourlyWeatherData.self, from: jsonData)

import Foundation

// MARK: - HourlyWeatherData
struct HourlyWeatherData: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [ListHourly]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
}

// MARK: - Coord
struct CoordHourly: Codable {
    let lat, lon: Double
}

// MARK: - List
struct ListHourly: Codable {
    let dt: Int
    let main: MainClassHourly
    let weather: [WeatherHourly]
    let clouds: CloudsHourly
    let wind: WindHourly
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct CloudsHourly: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClassHourly: Codable {
    let temp, tempMin, tempMax, pressure: Double
    let seaLevel, grndLevel: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
    }
}

// MARK: - Weather
struct WeatherHourly: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct WindHourly: Codable {
    let speed, deg: Double
}
