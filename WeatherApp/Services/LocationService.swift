//
//  LocationService.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreLocation

final class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var locationErrorMessage: String?
    
    override init() {
        super.init()
        setupLocationManager()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         locationErrorMessage =
        """
        Failed to find user's location.
        Please check location permissions in settings and restart the app.
        """
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationErrorMessage = nil
        currentLocation = location
    }
}

// MARK: - CALocation Methods
extension LocationService {
    
    private func setupLocationManager() {
        let errorMessage = "Location Permission Required. Please enable location permissions in settings."
        
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied, .notDetermined:
                locationErrorMessage = errorMessage
                
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationErrorMessage = nil
                
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 100
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            @unknown default: break
            }
        }
    
    func fetchCityAndCountry(from location: CLLocation,
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
}
