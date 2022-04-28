//
//  WeatherManager.swift
//  Clima
//
//  Created by Илья Шаповалов on 24.04.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0dfa512037afdbf8fb0a50e79fd1470c&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create URL-session
            let session = URLSession(configuration: .default)
            //3. Give the session to a task
            let task = session.dataTask(with: url) { data, responce, error in
                // Cheking for errors
                if error != nil {
                    print(error!)
                    return
                }
                // Cheking for data
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(weatherData: Data) {
         let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.name)
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
    
}
