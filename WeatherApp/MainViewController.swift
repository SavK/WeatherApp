//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/16/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit
import MapKit
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
    let locationManager = CLLocationManager()
    
    let updateLocationSemaphore = DispatchSemaphore(value: 0)
    let updateLocationQueue = DispatchQueue.init(label: "Update Location Queue", attributes: .concurrent)
    
    var adressDetected = false
    var currentAdress = ""

    
    // MARK: - UIViewController Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func detectLocationPress() {
        if currentAdressLabel.text != currentAdress {
            activityIndicator.startAnimating()
            locationStackView.isHidden = true
            createLocationManager()
            updateUI()
        }
    }
    
}

// MARK: - Update UI Methods
extension MainViewController {
    func updateUI() {
        updateLocationQueue.async {
            self.updateLocationSemaphore.wait()
            
            DispatchQueue.main.async {
                self.currentAdressLabel.text = self.currentAdress
                self.activityIndicator.stopAnimating()
                self.showWeatherButton.isHidden = !self.adressDetected
                self.locationStackView.isHidden = false
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        updateLocationQueue.async {
            self.fetchCityAndCountry(from: location) { street, city, country, error in
                guard error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                guard let street = street, let city = city, let country = country else {
                    print("Some adress data is nil")
                    return
                }
                self.currentAdress = street + ", " + city + ", " + country
                self.adressDetected = true
                self.updateLocationSemaphore.signal()
            }
        }
    }
}

// MARK: - CALocation Methods
extension MainViewController {
    
    private func fetchCityAndCountry(from location: CLLocation,
                                     completion: @escaping (_ street: String?,
                                                            _ city: String?,
                                                            _ country: String?,
                                                            _ error: Error?) -> ()) {
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.thoroughfare,
                       placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    private func createLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if !self.hasLocationPermission() {
            updateLocationQueue.async {
                
                if #available(iOS 10.0, *) {
                    DispatchQueue.main.async {
                        self.showAlert()
                    }
                } else {}
                self.currentAdress = "Location Permission Required. Please enable location permissions in settings."
                self.updateLocationSemaphore.signal()
            }
        }
    }
    /// Check location permission
    private func hasLocationPermission() -> Bool {
        var hasPermission = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            default:
                break
            }
        }
        return hasPermission
    }
}

// MARK: - Custom Methods
extension MainViewController {
    @available(iOS 10.0, *)
    func showAlert() {
        let alertController = UIAlertController(title: "Location Permission Required",
                                                message: "Please enable location permissions in settings.",
                                                preferredStyle: UIAlertController.Style.alert)
        
        /// Redirect to Settings app
        let okAction = UIAlertAction(title: "Settings",
                                     style: .default,
                                     handler: { _ in
                                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
