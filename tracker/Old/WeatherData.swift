//
//  WeatherData.swift
//  tracker
//
//  Created by Daniel Paymar on 6/24/24.
//

import Foundation
import SwiftData

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
