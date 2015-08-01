//
//  NSNumberFormatter.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
    
    func currencyFromNumber(number: Double) -> String {
        self.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.currencyCode = "USD"
        return self.stringFromNumber(number)!
    }
    
    func priceFromNumber(number: Double) -> String {
        return NSString(format:"%0.2f", number) as String
    }
    
    func priceChangeFromNumber(number: Double) -> String {
        return NSString(format:"%+0.2f", number) as String
    }
    
    func percentChangeFromNumber(number: Double) -> String {
        return NSString(format:"%+0.2f%%", number) as String
    }
    
}