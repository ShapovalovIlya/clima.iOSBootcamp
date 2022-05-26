//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Co-creator Ilia Shapovalov 20/04/2022
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationMAnager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMAnager.delegate = self
        locationMAnager.requestWhenInUseAuthorization()
        locationMAnager.requestLocation()
        
       
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func currentLocationTapped(_ sender: UIButton) {
        locationMAnager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextViewDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    @objc internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            temperatureLabel.text = weather.temperatureString
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationMAnager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationMAnager.stopUpdatingLocation()
    }
    
}

