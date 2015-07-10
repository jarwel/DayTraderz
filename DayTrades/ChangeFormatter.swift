//
//  ChangeFormatter.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ChangeFormatter: NSObject {
    
    class func stringFromQuote(quote: Quote) -> String {
        let priceChange: Double = quote.priceChange
        let percentChange: Double = quote.percentChange
        return stringFromChange(priceChange, percentChange: percentChange)
    }
    
    class func stringFromPick(pick: Pick) -> String {
        let priceChange: Double = pick.close - pick.open;
        let percentChange: Double = priceChange / pick.open * 100;
        return stringFromChange(priceChange, percentChange: percentChange)
    }
    
    class func stringFromChange(priceChange: Double, percentChange: Double) -> String {
        let priceChangeFormat: NSString = NSString(format:"%+0.2f", priceChange)
        let percentChangeFormat: NSString = NSString(format:"%+0.2f%%", percentChange)
        return "\(priceChangeFormat) (\(percentChangeFormat))"
    }
    
}