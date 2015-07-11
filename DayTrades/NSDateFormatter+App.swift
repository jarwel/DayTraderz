//
//  NSDateFormatter+App.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSDateFormatter {
  
    func shortStringFromDayOfTrade(dayOfTrade: DayOfTrade) -> String {
        let date = dayOfTrade.dateValue()
        self.dateFormat = "E, MMM d"
        self.timeZone = NSTimeZone(name: "UTC")
        return self.stringFromDate(date)
    }
    
    func fullStringFromDayOfTrade(dayOfTrade: DayOfTrade) -> String {
        let date = dayOfTrade.dateValue()
        self.dateFormat = "EEEE, MMMM d, yyyy"
        self.timeZone = NSTimeZone(name: "UTC")
        return self.stringFromDate(date)
    }
    
}