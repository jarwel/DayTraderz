//
//  NSCalendarTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class NSCalendarTests: XCTestCase {
    
    func testGregorianCalendarInEasternTime() {
        let calendar: NSCalendar = NSCalendar.gregorianCalendarInEasternTime()
        let timeZone: NSTimeZone = NSTimeZone(name: "America/New_York")!
        XCTAssertEqual(calendar.timeZone, timeZone)
    }
    
}
