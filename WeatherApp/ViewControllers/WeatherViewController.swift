//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreData

class WeatherViewController: UIViewController {
    
    // MARK: - IBOutlets
    /// Labels
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var tempreatureLabel: UILabel!
    /// Other UI Elements
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var labelStack: UIStackView!
    
    // MARK: - Properties
    private let updateWeatherDispatchGroup = DispatchGroup()
    private var weather: Weather?
    private var isElementsVisible = true
    
    var street = ""
    var currentLatitude = ""
    var currentLongitude = ""
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeElementsVisibility(if: isElementsVisible)
        fetchWeather()
        updateWeatherDispatchGroup.notify(queue: DispatchQueue.main) {
            self.updateUI()
            if #available(iOS 10.0, *) { self.saveToDB() } else {}
        }
    }
    
    // MARK: - IBActions
    @IBAction func refreshPress() {
        changeElementsVisibility(if: isElementsVisible)
        fetchWeather()
        updateWeatherDispatchGroup.notify(queue: DispatchQueue.main) {
            self.updateUI()
            if #available(iOS 10.0, *) { self.saveToDB() } else {}
        }
    }
}

// MARK: - UI Methods
extension WeatherViewController {
    
    func updateUI() {
        cityLabel.text = weather?.location.city
        textLabel.text = weather?.currentObservation.condition.text
        tempreatureLabel.text = "\(weather?.currentObservation.condition.temperature ?? 100)ºC"
        changeElementsVisibility(if: isElementsVisible)
    }
    
    func changeElementsVisibility(if status: Bool) {
        isElementsVisible.toggle()
        labelStack.isHidden = status
        isElementsVisible ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
}

// MARK: - Custom Methods
extension WeatherViewController {
    
    func fetchWeather() {
        updateWeatherDispatchGroup.enter()
        YahooWeatherAPI.shared.weather(lat: currentLatitude,
                                       lon: currentLongitude,
                                       failure: { [unowned self] error in
                                        print(error.localizedDescription)
                                        self.updateWeatherDispatchGroup.leave()
        },
                                       success: { [unowned self] response in
                                        NetworkService.decodeJSON(from: response.data) { result in
                                            self.weather = result
                                        }
                                        self.updateWeatherDispatchGroup.leave()
        })
    }
}

@available(iOS 10.0, *)
extension WeatherViewController {

    func saveToDB() {
        
        do {
            guard let weather = weather, let context = ContextSingltone.shared.context else { return }
            let newWeather = WeatherEntity(context: context)
            newWeather.street = street
            newWeather.temperature = Int64(weather.currentObservation.condition.temperature)
            newWeather.city = weather.location.city
            newWeather.requestTime = Date().formattedDate

            try context.save()
        } catch {
            let saveError = error as NSError
            print("Save to DB ERROR: \(saveError), \(saveError.userInfo)")
        }
    }
}
