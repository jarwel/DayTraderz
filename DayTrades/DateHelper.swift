//
//  DateHelper.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class DateHelper {
    
    static func isMarketOpenOnDate(date: NSDate) -> Bool {
        let calendar: NSCalendar = easternCalendar()
        let components: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date)
        let weekday: Int = components.weekday
        if weekday < 2 || weekday > 6 {
            return false
        }
        return true
    }
    
    class func nextDayOfTrade() -> String? {
        let date: NSDate = NSDate()
        return nextDayOfTradeFromDate(date)
    }
    
    class func nextDayOfTradeFromDate(var date: NSDate) -> String? {
        let calendar: NSCalendar = easternCalendar()
        let components: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date)
        let hour: Int = components.hour
        if hour >= 9 || !isMarketOpenOnDate(date) {
            do {
                date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 1, toDate: date, options: nil)!
            }
            while (!isMarketOpenOnDate(date))
        }
        let dateFormatter: NSDateFormatter = easternDateFormatter()
        let dayOfTrade: String = easternDateFormatter().stringFromDate(date)
        return dayOfTrade

    }
    
    class func lastDayOfTrade() -> String? {
        let date: NSDate = NSDate()
        return lastDayOfTradeFromDate(date)
    }
    
    class func lastDayOfTradeFromDate(var date: NSDate) -> String? {
        let calendar: NSCalendar = easternCalendar()
        let components: NSDateComponents = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date)
        let hour: Int = components.hour
        if hour < 9 || !isMarketOpenOnDate(date) {
            do {
                date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -1, toDate: date, options: nil)!
            }
            while (!isMarketOpenOnDate(date))
        }
        let dateFormatter: NSDateFormatter = easternDateFormatter()
        let dayOfTrade: String = dateFormatter.stringFromDate(date)
        return dayOfTrade
    }
    
    static func easternCalendar() -> NSCalendar {
        let calendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "America/New_York")!
        return calendar
    }
    
    static func easternDateFormatter() -> NSDateFormatter {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "America/New_York")
        return dateFormatter
    }
    
}