//
//  NSNumberFormatter.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
    
    func currencyFromNumber(number: NSNumber) -> String {
        self.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.currencyCode = "USD"
        return self.stringFromNumber(number)!
    }
    
    func priceFromNumber(number: NSNumber) -> String {
        return NSString(format:"%0.2f", number.doubleValue) as String
    }
    
    func priceChangeFromNumber(number: NSNumber) -> String {
        return NSString(format:"%+0.2f", number.doubleValue) as String
    }
    
    func percentChangeFromNumber(number: NSNumber) -> String {
        return NSString(format:"%+0.2f%%", number.doubleValue) as String
    }
    
}