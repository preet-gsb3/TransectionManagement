//
//  Extensions.swift
//  GurpreetTest
//
//  Created by Gurpreet Singh on 01/09/20.
//  Copyright © 2020 Gurpreet Singh. All rights reserved.
//

import Foundation

extension String {
    func timestampToDate() -> Date {
        let value = (self as NSString).doubleValue / 1000
        return Date(timeIntervalSince1970: value)
    }
    
    var isValidNumber: Bool {
        let charcter  = NSCharacterSet(charactersIn: "0123456789").inverted
        var filtered:String!
        let inputString = self.components(separatedBy: charcter)
        filtered = inputString.joined(separator: "")
        return self == filtered
    }
}

extension Date {
    func toTimeStamp() -> String {
        let timestamp13Digit = Int64(self.timeIntervalSince1970 * 1000)
        return "\(timestamp13Digit)"
    }
}
