//
//  NSNumberFormatter+USD.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
    
    func USDFromDouble(value: Double) -> String {
        let number: NSNumber = NSNumber(double: value)
        self.numberStyle = .CurrencyStyle
        self.currencyCode = "USD"
        return self.stringFromNumber(number)!
    }
    
}