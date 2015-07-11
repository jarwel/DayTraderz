//
//  DayOfTrade.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class DayOfTrade {
    
    var date: NSDate
    
    init(date: NSDate) {
        self.date = date
    }

    convenience init?(string: String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        if let date = dateFormatter.dateFromString(string) {
            self.init(date: date)
        }
        else {
            self.init(date: NSDate())
            return nil
        }
    }
    
    func dateValue() -> NSDate {
        return date
    }
    
    func stringValue() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "America/New_York")
        return dateFormatter.stringFromDate(date)
    }
    
    static func nextDayOfTrade() -> DayOfTrade? {
        let date = NSDate()
        return nextDayOfTrade(date)
    }
    
    static func nextDayOfTrade(var date: NSDate) -> DayOfTrade? {
        let calendar = initCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date)
        let hour = components.hour
        if hour >= 9 || !isMarketOpenOnDate(date) {
            do {
                date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 1, toDate: date, options: nil)!
            }
            while (!isMarketOpenOnDate(date))
        }
        return DayOfTrade(date: date)
    }
    
    static func lastDayOfTrade() -> DayOfTrade? {
        let date = NSDate()
        return nextDayOfTrade(date)
    }
    
    static func lastDayOfTrade(var date: NSDate) -> DayOfTrade? {
        let calendar = initCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date)
        let hour = components.hour
        if hour < 9 || !isMarketOpenOnDate(date) {
            do {
                date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -1, toDate: date, options: nil)!
            }
            while (!isMarketOpenOnDate(date))
        }
        return DayOfTrade(date: date)
    }
    
    static func isMarketOpenOnDate(date: NSDate) -> Bool {
        let calendar = initCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date)
        if components.weekday > 1 && components.weekday < 7 {
            return true
        }
        return false
    }
    
    static func initCalendar() -> NSCalendar {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "America/New_York")!
        return calendar
    }
    
}