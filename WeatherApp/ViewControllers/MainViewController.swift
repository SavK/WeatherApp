//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/16/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    /// StackView
    @IBOutlet private var locationStackView: UIStackView!
    /// Labels
    @IBOutlet private var currentAdressLabel: UILabel!
    /// Buttons
    @IBOutlet private var detectLocationButton: UIButton!
    @IBOutlet private var showWeatherButton: UIButton!
    
    // MARK: - Properties
    private let locationServiceDispatchGroup = DispatchGroup()
    private var locationService: LocationService?
    private var currentLongitude = ""
    private var currentLatitude = ""
    private var currentAdress = ""
    private var isAdressDetected = false
    
    
    // MARK: - UIViewController Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationService = LocationService()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationService = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func detectLocationPress() {
        isAdressDetected = false
        activityIndicator.startAnimating()
        locationStackView.isHidden = true
        updateLocationInfo()
        DispatchQueue.global().async {
            self.locationServiceDispatchGroup.wait()
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
}

// MARK: - Update UI Methods
extension MainViewController {
    
    private func updateUI() {
        currentAdressLabel.text = currentAdress
        activityIndicator.stopAnimating()
        locationStackView.isHidden = false
        showWeatherButton.isHidden = !isAdressDetected
    }
}

// MARK: - Custom Methods
extension MainViewController {
    @available(iOS 10.0, *)
    private func showAlert() {
        let alertController = UIAlertController(title: "Location Permission Required",
                                                message:
            """
            Please enable location permissions in settings and restart the app.
            """,
                                                preferredStyle: UIAlertController.Style.alert)
        
        /// Redirect to Settings app
        let okAction = UIAlertAction(title: "Settings",
                                     style: .default,
                                     handler: { _ in
                                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                                        self.locationService = nil
                                        self.locationService = LocationService()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateLocationInfo() {
        guard locationService?.locationErrorMessage == nil
            else {
                if #available(iOS 10.0, *) { showAlert() } else {}
                currentAdress = locationService?.locationErrorMessage ?? "Error with location service"
                return
        }
        guard let location = locationService?.currentLocation else { return }
        
        currentLongitude = String(format: "%.4f",location.coordinate.longitude)
        currentLatitude = String(format: "%.4f", location.coordinate.latitude)
        
        locationServiceDispatchGroup.enter()
        locationService?.fetchCityAndCountry(from: location) {
            [unowned self] (street, city, country, error) in
            
            defer { self.locationServiceDispatchGroup.leave() }
            
            guard error == nil else {
                self.currentAdress = "Error: \(error!.localizedDescription)"
                return
            }
            
            guard let street = street, let city = city, let country = country else {
                self.currentAdress = "Some adress data isn't detected"
                return
            }
            
            self.currentAdress = street + ", " + city + ", " + country
            self.isAdressDetected = true
        }
    }
}
