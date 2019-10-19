//
//  Weather.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let location: Location
    let currentObservation: CurrentObservation
    
    enum CodingKeys: String, CodingKey {
        case location
        case currentObservation = "current_observation"
    }
}
// MARK: - CurrentObservation
struct CurrentObservation: Codable {
    let condition: Condition
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let temperature: Int
}

// MARK: - Location
struct Location: Codable {
    let city, country: String
}
