//
//  YahooWeatherAPIService.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import OAuthSwift

class YahooWeatherAPI {
    // Configure the following with your values.
    private let credentials = YahooWeatherAPIClientCredentials(appId: AuthenticationYahooAPIData.appId,
                                                               clientId: AuthenticationYahooAPIData.clientId,
                                                               clientSecret: AuthenticationYahooAPIData.clientSecret)
    
    private let url: String = "https://weather-ydn-yql.media.yahoo.com/forecastrss"
    private let oauth: OAuth1Swift?
 
    public static let shared = YahooWeatherAPI()
 
    private init() {
        self.oauth = OAuth1Swift(consumerKey: self.credentials.clientId,
                                 consumerSecret: self.credentials.clientSecret)
    }

    private var headers:[String: String] {
        return [
            "X-Yahoo-App-Id": self.credentials.appId
        ]
    }
    
    /// Requests weather data by location name.
    ///
    /// - Parameters:
    ///   - location: the name of the location, i.e. sunnyvale,ca
    ///   - failure: failure callback
    ///   - success: success callback
    ///   - responseFormat: .xml or .json. default is .json.
    ///   - unit: metric or imperial units. default = .imperial
    public func weather(location: String,
                        failure: @escaping (_ error: OAuthSwiftError) -> Void,
                        success: @escaping (_ response: OAuthSwiftResponse) -> Void,
                        responseFormat: YahooWeatherAPIResponseType = .json,
                        unit: YahooWeatherAPIUnitType = .imperial) {
        
        self.makeRequest(parameters: ["location": location,
                                      "format": responseFormat.rawValue,
                                      "u": unit.rawValue],
                         failure: failure,
                         success: success)
    }
    
    
    /// Requests weather data by woeid (Where on Earth ID)
    ///
    /// - Parameters:
    ///   - woeid: The location's woeid
    ///   - failure: failure callback
    ///   - success: success callback
    ///   - responseFormat: .xml or .json. default is .json.
    ///   - unit: metric or imperial units. default = .imperial
    public func weather(woeid: String,
                        failure: @escaping (_ error: OAuthSwiftError) -> Void,
                        success: @escaping (_ response: OAuthSwiftResponse) -> Void,
                        responseFormat: YahooWeatherAPIResponseType = .json,
                        unit: YahooWeatherAPIUnitType = .imperial) {
        
        self.makeRequest(parameters: ["woeid": woeid,
                                      "format": responseFormat.rawValue,
                                      "u": unit.rawValue],
                         failure: failure,
                         success: success)
    }
    
    
    /// Requests weather data by latitude and longitude
    ///
    /// - Parameters:
    ///   - lat: latitude
    ///   - lon: longiture
    ///   - failure: failure callback
    ///   - success: success callback
    ///   - responseFormat: .xml or .json. default is .json.
    ///   - unit: metric or imperial units. default = .imperial
    public func weather(lat: String,
                        lon: String,
                        failure: @escaping (_ error: OAuthSwiftError) -> Void,
                        success: @escaping (_ response: OAuthSwiftResponse) -> Void,
                        responseFormat: YahooWeatherAPIResponseType = .json,
                        unit: YahooWeatherAPIUnitType = .metric) {
        
        self.makeRequest(parameters: ["lat": lat,
                                      "lon": lon,
                                      "format": responseFormat.rawValue,
                                      "u": unit.rawValue],
                         failure: failure,
                         success: success)
    }
    
    
    /// Performs the API request with the OAuthSwift client
    ///
    /// - Parameters:
    ///   - parameters: Any URL parameters to pass to the endpoint.
    ///   - failure: failure callback
    ///   - success: success callback
    private func makeRequest(parameters:[String: String],
                             failure: @escaping (_ error: OAuthSwiftError) -> Void,
                             success: @escaping (_ response: OAuthSwiftResponse) -> Void) {
        
        self.oauth?.client.request(self.url,
                                   method: .GET,
                                   parameters: parameters,
                                   headers: self.headers,
                                   body: nil,
                                   checkTokenExpiration: true,
                                   completionHandler: { result in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error)
            }
        })
    }
}

