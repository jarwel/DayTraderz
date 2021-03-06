//
//  NSDateFormatter.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSDateFormatter {
  
    func fullTextFromDayOfTrade(dayOfTrade: String?) -> String? {
        if dayOfTrade != nil {
            self.dateFormat = "yyyy-MM-dd"
            self.timeZone = NSTimeZone(name: "UTC")
            if let date = self.dateFromString(dayOfTrade!) {
                self.dateFormat = "EEEE, MMMM d, yyyy"
                return self.stringFromDate(date)
            }
        }
        return nil
    }
    
    func pickTextFromDayOfTrade(dayOfTrade: String?) -> String? {
        if dayOfTrade != nil {
            self.dateFormat = "yyyy-MM-dd"
            self.timeZone = NSTimeZone(name: "UTC")
            if let date = self.dateFromString(dayOfTrade!) {
                self.dateFormat = "E, MMM d"
                return self.stringFromDate(date)
            }
        }
        return nil
    }
    
    func chartTextFromDayOfTrade(dayOfTrade: String?) -> String? {
        if dayOfTrade != nil {
            self.dateFormat = "yyyy-MM-dd"
            self.timeZone = NSTimeZone(name: "UTC")
            if let date = self.dateFromString(dayOfTrade!) {
                self.dateFormat = "MMMdd"
                return self.stringFromDate(date)
            }
        }
        return nil
    }
    
}