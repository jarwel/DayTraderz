//
//  NSNumberFormatter+App.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
    
    func USDFromDouble(value: Double) -> String {
        let number: NSNumber = NSNumber(double: value)
        self.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        self.currencyCode = "USD"
        return self.stringFromNumber(number)!
    }
    
    func priceFromDouble(value: Double) -> String {
        return NSString(format:"%0.2f", value) as String
    }
    
}