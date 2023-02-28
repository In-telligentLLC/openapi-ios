//
//  Date.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit

/// handles date and time of alerts 
extension Date {
    
    //MARK: Static methods 
    /// converts a string into date and returns date
    /// - Parameter dateFormat: a string value
    /// - Returns: a date which is converted from string format to date format
    func formattedDate(from dateFormat: String) -> Date? {
        let dateString = self.toString(with: dateFormat)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    /// converts a date into string and returns string
    /// - Parameter format: a string value
    /// - Returns: a string which is converted from date format to string format 
    func toString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
