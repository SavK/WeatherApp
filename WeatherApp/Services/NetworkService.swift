//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

final class NetworkService {
    
    static func decodeJSON<T: Decodable> (from data: Data,
                              complition: @escaping (_ decodedData: T?) -> ()) {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            complition(result)
            
        } catch let decodeError {
            print(#line, #function, "Decode Error: \(decodeError.localizedDescription)")
            complition(nil)
        }
    }
}
