//
//  ChangeFormatter.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ChangeFormatter {
    
    let numberFormatter: NSNumberFormatter = NSNumberFormatter()
    
    func textFromQuote(quote: Quote) -> String {
        let priceChange: Double = quote.priceChange
        let percentChange: Double = quote.percentChange
        return textFromChange(priceChange, percentChange: percentChange)
    }
    
    func textFromPick(pick: Pick) -> String {
        let percentChange: Double = pick.change / pick.value * 100;
        return textFromChange(pick.change, percentChange: percentChange)
    }
    
    func textFromChange(priceChange: Double, percentChange: Double) -> String {
        let priceChangeFormat: String = numberFormatter.priceChangeFromNumber(priceChange)
        let percentChangeFormat: String = numberFormatter.percentChangeFromNumber(percentChange)
        return "\(priceChangeFormat) (\(percentChangeFormat))"
    }
    
}