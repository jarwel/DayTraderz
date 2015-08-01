//
//  NSCalendar.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

extension NSCalendar {
    
    static func gregorianCalendarInEasternTime() -> NSCalendar {
        let calendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "America/New_York")!
        return calendar
    }
    
}