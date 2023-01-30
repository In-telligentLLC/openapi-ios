//
//  Date.swift
//  iosOpenAPIDemo
//
//  Created by Likhitha  Narayana on 07/01/23.
//

import UIKit

extension Date {
    
    /// converts a string into date and returns date
    func formattedDate(from dateFormat: String) -> Date? {
        let dateString = self.toString(with: dateFormat)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    /// converts a date into string and returns string
    func toString(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
