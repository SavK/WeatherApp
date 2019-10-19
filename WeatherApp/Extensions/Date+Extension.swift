//
//  Date+Extension.swift
//  ToDoList
//
//  Created by Savonevich Constantine on 7/1/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import Foundation

extension Date {
    
    // MARK: - Property returns formatted date in string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
