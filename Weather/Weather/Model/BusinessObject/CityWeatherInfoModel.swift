//
//  CityWeatherInfoModel.swift
//  Weather
//
//  Created by Administrator on 27/03/18.
//  Copyright © 2018 Anubhav Jain. All rights reserved.
//

import Foundation

struct CityWeatherInfoRootModel: Codable {
    let cnt : Int?
    let list : [CityWeatherInfoModel]?
    
    enum CodingKeys: String, CodingKey {
        case cnt = "cnt"
        case list = "list"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt)
        list = try values.decodeIfPresent([CityWeatherInfoModel].self, forKey: .list)
    }
}

struct CityWeatherInfoModel: Codable {
    let id: Double
    let dt: Double
    let name: String
    let main : DetailInfoModel
}

struct DetailInfoModel: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let tempMin : Double
    let tempMax : Double
    enum CodingKeys: String, CodingKey {
        case humidity = "humidity"
        case pressure = "pressure"
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}


