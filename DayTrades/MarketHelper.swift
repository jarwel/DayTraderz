//
//  MarketHelper.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class MarketHelper: NSObject {
    
    class func isMarketOpen(date: NSDate) -> Bool {
        let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
        let hour: Int = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date).hour
        if hour < 9 || hour >= 16 {
            return false
        }
        if hour == 9 {
            let minute: Int = calendar.components(NSCalendarUnit.CalendarUnitMinute, fromDate: date).minute
            if minute < 30 {
                return false
            }
        }
        return isDayOfTrade(date)
    }
    
    class func nextDayOfTrade() -> String? {
        let date: NSDate = NSDate()
        return nextDayOfTradeFromDate(date)
    }
    
    class func nextDayOfTradeFromDate(var date: NSDate) -> String? {
        let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
        let hour: Int = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date).hour
        if hour >= 9 || !isDayOfTrade(date) {
            do {
                date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: 1, toDate: date, options: nil)!
            }
            while (!isDayOfTrade(date))
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
        let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
        let hour: Int = calendar.components(NSCalendarUnit.CalendarUnitHour, fromDate: date).hour
        if hour < 9 || !isDayOfTrade(date) {
            do {
                date = calendar.dateByAddingUnit(NSCalendarUnit.CalendarUnitDay, value: -1, toDate: date, options: nil)!
            }
            while (!isDayOfTrade(date))
        }
        let dateFormatter: NSDateFormatter = easternDateFormatter()
        let dayOfTrade: String = dateFormatter.stringFromDate(date)
        return dayOfTrade
    }
    
    static func isDayOfTrade(date: NSDate) -> Bool {
        let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
        let weekday: Int = calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date).weekday
        if weekday < 2 || weekday > 6 {
            return false
        }
        let holidays: NSArray = NSBundle.mainBundle().objectForInfoDictionaryKey("Market holidays") as! NSArray
        let string: String = easternDateFormatter().stringFromDate(date)
        return !holidays.containsObject(string)
    }
    
    static func easternDateFormatter() -> NSDateFormatter {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "America/New_York")
        return dateFormatter
    }
    
}