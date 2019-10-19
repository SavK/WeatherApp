//
//  ContextSingltone.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/19/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import CoreData

final class ContextSingltone {
    static let shared = ContextSingltone()
    var context: NSManagedObjectContext?
}
