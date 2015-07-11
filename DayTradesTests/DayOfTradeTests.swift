//
//  DayOfTradeTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class DayOfTradeTest: XCTestCase {
    
    func testNextDayOfTrade() {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        if let date: NSDate? = dateFormatter.dateFromString("2015-07-09T04:29:00") {
            if let dayOfTrade: DayOfTrade? = DayOfTrade.nextDayOfTrade(date!) {
                XCTAssertEqual("2015-07-10", dayOfTrade!.stringValue())
            }
        }
    }
    
}
