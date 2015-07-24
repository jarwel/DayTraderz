//
//  ChangeFormatter.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ChangeFormatter {
    
    class func stringFromQuote(quote: Quote) -> String {
        let priceChange: Double = quote.priceChange
        let percentChange: Double = quote.percentChange
        return stringFromChange(priceChange, percentChange: percentChange)
    }
    
    class func stringFromPick(pick: Pick) -> String {
        let percentChange: Double = pick.change / pick.value * 100;
        return stringFromChange(pick.change, percentChange: percentChange)
    }
    
    class func stringFromChange(priceChange: Double, percentChange: Double) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        let priceChangeFormat: String = numberFormatter.priceChangeFromNumber(NSNumber(double: priceChange))
        let percentChangeFormat: String = numberFormatter.percentChangeFromNumber(NSNumber(double: percentChange))
        return "\(priceChangeFormat) (\(percentChangeFormat))"
    }
    
}