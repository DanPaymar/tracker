//
//  WeatherManager.swift
//  tracker
//
//  Created by Daniel Paymar on 6/24/24.
//

import Foundation
import SwiftData
import Combine

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager: ObservableObject {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "7f97f84850d785a42102b9ecfa379253"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)?q=\(cityName)&appid=\(apiKey)&units=metric"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. create a url
        if let url = URL(string: urlString) {
            
            // 2. create url session
            let session = URLSession(configuration: .default)
            
            // 3. give the session a task using a closure
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather =  self.parsJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                
            }
            
            // 4. start the task
            task.resume()
            
        }
    }
    
    func parsJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(
                conditionId: id,
                cityName: name,
                temperature: temp
            )
            return weather

        } catch {
           delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
}
