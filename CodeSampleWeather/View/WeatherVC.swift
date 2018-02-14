//
//  WeatherVC.swift
//  CodeSampleWeather
//
//  Created by sadie on 2/12/18.
//  Copyright © 2018 Sadie Contini. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherTitleLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var weather: Weather? {
        didSet {
            populateWeatherInfo(with: weather)
        }
    }
    
    let dataManager = DataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weather = nil
        refetchWeather()
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        submitSearchForm()
    }
    
    func submitSearchForm() {
        if let text = searchTextField.text,
            !text.isEmpty {
            if text.isNumber {
                showErrorMessage("Make sure you enter a city name and not a zip code.")
            } else {
                searchTextField.resignFirstResponder()
                fetchWeather(for: text)
            }
        }
    }
    
    // MARK: - Update UI
    func populateWeatherInfo(with weather: Weather?) {
        guard let currentWeather = weather else {
            clearWeatherUI()
            return
        }
        if let iconName = weather?.titleIconName {
            fetchWeatherIcon(for: iconName)
        }
        cityNameLabel?.text = currentWeather.cityName + " (" + currentWeather.country + ")"
        weatherTitleLabel?.text = currentWeather.title
        currentTempLabel?.text = "\(currentWeather.temp)℃"
        maxMinLabel?.text = "\(currentWeather.tempMax)°/\(currentWeather.tempMin)°"
    }
    
    func clearWeatherUI() {
        cityNameLabel?.text = ""
        weatherTitleLabel?.text = ""
        currentTempLabel?.text = ""
        maxMinLabel?.text = ""
        weatherIconImageView.image = nil
    }
    
    // MARK: - Fetch Data
    func refetchWeather() {
        if let lastSearchCity = UserDefaultsManager.lastSearchCity() {
            searchTextField?.text = lastSearchCity
            fetchWeather(for: lastSearchCity)
        }
    }
    
    func fetchWeather(for cityName: String) {
        dataManager.fetchWeather(for: cityName) {
            [weak self] (result: APIResult) in
            
            guard let wSelf = self else {
                return
            }
            switch result {
            case .success(let weather):
                UserDefaultsManager.setLastSearchCity(name: cityName)
                wSelf.errorLabel?.isHidden = true
                wSelf.weather = weather
            case .error(let error):
                // TODO: handle difference between no city with that name
                // and no server response
                wSelf.showErrorMessage(error.userMessage)
                print(error.debugMessage)
            }
        }
    }
    
    func fetchWeatherIcon(for iconName: String) {
        dataManager.fetchWeatherIcon(for: iconName) {
            [weak self] (result: APIResult) in
            switch result {
            case .success(let iconData):
                self?.weatherIconImageView.image = UIImage.init(data: iconData)
            case .error(let error):
                error.handle()
            }
        }
    }
    
    func showErrorMessage(_ message: String) {
        errorLabel?.text = message
        errorLabel?.isHidden = false
    }
}

extension WeatherVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            submitSearchForm()
            return false
        }
        return true
    }
}

// TODO: move to extension file
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
