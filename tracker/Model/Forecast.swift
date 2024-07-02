//
//  Forecast.swift
//  WeatherApi
//
//  Created by Daniel Paymar on 6/27/24.
//

import UIKit
import CoreLocation
import Foundation
import SwiftData


struct Forecast: Codable {
        
    struct Daily: Codable {
        let dt: Date
        
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        
        let temp: Temp
        let humidity: Int
        
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
        }
        
        let weather: [Weather]
        let clouds: Int
        let pop: Double
    }
    
    let daily: [Daily]

}

