//
//  WeatherManager.swift
//  Clima
//
//  Created by Илья Шаповалов on 24.04.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(APIKey().key)c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create URL
        guard let url = URL(string: urlString) else { return }
            //2. Create URL-session
            let session = URLSession(configuration: .default)
            //3. Give the session to a task
            let task = session.dataTask(with: url) { data, responce, error in
                // Cheking for errors
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                // Cheking for data
                guard let safeData = data else { return }
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
            }
            //4. Start the task
            task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? { 
         let decoder = JSONDecoder()
        do {
            // Try to decode data from task
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
        
}
