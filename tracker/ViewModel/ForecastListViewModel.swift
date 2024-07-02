//
//  ForecastListViewModel.swift
//  WeatherApi
//
//  Created by Daniel Paymar on 6/28/24.
//

import CoreLocation
import Foundation
import SwiftUI
import SwiftData


class ForecastListViewModel: ObservableObject {
    var trip: Trip?
    
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    
    @Published var isLoading: Bool = false
    
    @AppStorage("location") var storagelocation: String = ""
    @Published var location = ""
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    
    init() {
        location = storagelocation
        getWeatherForecast()
    }
    
    func getWeatherForecast() {
        storagelocation = location
        UIApplication.shared.endEditing()
        if location == "" {
            forecasts = []
        } else {
            isLoading = true
            let apiService = APIService.shared
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if let error = error as? CLError {
                    switch error.code {
                        
                    case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                        self.appError = AppError(
                            errorString: NSLocalizedString("Unable to determine location", comment: "")
                        )
                    case .network:
                        self.appError = AppError(
                            errorString: NSLocalizedString("No network connection. Please check you are connected to a network and try again.", comment: "")
                        )
           default:
                        self.appError = AppError(
                            errorString: error.localizedDescription
                        )
                    }
                    self.isLoading = false
                    self.appError = AppError(errorString: error.localizedDescription)
                    print(error.localizedDescription)
                }
                if let lat = placemarks?.first?.location?.coordinate.latitude,
                   let lon = placemarks?.first?.location?.coordinate.longitude {
                   
                    apiService.getJSON(urlString: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=3989ab9921804406367d1e47d782024a",
                                       dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                        
                        switch result {
                        case .success(let forecast):
                            DispatchQueue.main.async {
                                self.isLoading = false
                                self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system)}
                            }
                        case .failure(let apiError):
                            switch apiError {
                            case .error(let errorString):
                                self.isLoading = false
                                self.appError = AppError(errorString: errorString)
                                print(errorString)
                            }
                        }
                    }
                }
            }
        }
    }
}
