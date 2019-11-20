// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hourlyWeatherData = try? newJSONDecoder().decode(HourlyWeatherData.self, from: jsonData)

import Foundation

// MARK: - HourlyWeatherData
struct HourlyWeatherData: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [ListHourly]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: CoordHourly?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct CoordHourly: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct ListHourly: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [WeatherHourly]?
    let clouds: CloudsHourly?
    let wind: WindHourly?
    let dtTxt: String?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case dtTxt = "dt_txt"
        case rain
    }
}

// MARK: - Clouds
struct CloudsHourly: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}


enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct WeatherHourly: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription: Description?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

// MARK: - Wind
struct WindHourly: Codable {
    let speed: Double?
    let deg: Int?
}
