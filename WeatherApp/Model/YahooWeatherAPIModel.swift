//
//  YahooWeatherAPIModel.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

enum YahooWeatherAPIResponseType: String {
    case json = "json"
    case xml = "xml"
}

enum YahooWeatherAPIUnitType: String {
    case imperial = "f"
    case metric = "c"
}

struct YahooWeatherAPIClientCredentials {
    var appId = ""
    var clientId = ""
    var clientSecret = ""
}
