//
//  WeatherEntity+CoreDataProperties.swift
//  
//
//  Created by Savonevich Constantine on 10/19/19.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var temperature: Int64
    @NSManaged public var requestTime: String
    @NSManaged public var city: String
    @NSManaged public var street: String

}
