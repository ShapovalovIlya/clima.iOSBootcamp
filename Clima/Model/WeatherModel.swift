//
//  WeatherModel.swift
//  Clima
//
//  Created by Илья Шаповалов on 29.04.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...299:
            return "cloud.bolt"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.rain"
        case 600...699:
            return "snowflake"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        case 701, 741:
            return "cloud.fog"
        case 711:
            return "smoke"
        case 721:
            return "sun.haze"
        case 731, 761:
            return "sun.dust"
        case 781:
            return "tornado"
        default:
            return "cloud"
        }
    }

}
