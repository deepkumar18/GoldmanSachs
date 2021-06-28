//
//  APIResponseModel.swift
//  GoldmanSachs
//
//  Created by Deep Kumar on 19/06/21.
//

import Foundation

struct WeatherAPIResponseModel: Codable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: [List]
}

struct List: Codable {
    var dt: Int
    var main: Main
}

struct Main: Codable {
    var temp: Float
    var feels_like: Float
    var temp_min: Float
    var temp_max: Float
    var pressure: Int
    var humidity: Int
    var seaLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp,feels_like,temp_min,temp_max
        case seaLevel = "sea_level"
        case pressure,humidity
    }
}
