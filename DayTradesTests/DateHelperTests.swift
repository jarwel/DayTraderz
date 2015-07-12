//
//  DateHelperTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class DateHelperTests: XCTestCase {
    
    var utcFormatter: NSDateFormatter?
    var easternFormatter: NSDateFormatter?
    
    override func setUp() {
        super.setUp()
        
        utcFormatter = NSDateFormatter()
        utcFormatter!.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        utcFormatter!.timeZone = NSTimeZone(name: "UTC")
        
        easternFormatter = NSDateFormatter()
        easternFormatter!.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        easternFormatter!.timeZone = NSTimeZone(name: "America/New_York")
    }
    
    override func tearDown() {
        utcFormatter = nil
        easternFormatter = nil
        super.tearDown()
    }
    
    func testMarketIsOpen() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-06T09:30:00")
        let isMarketOpen: Bool = DateHelper.isMarketOpenOnDate(date!)
        XCTAssertTrue(isMarketOpen)
    }
    
    func testMarketIsClosedOnSaturday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-11T09:30:00")
        let isMarketOpen: Bool = DateHelper.isMarketOpenOnDate(date!)
        XCTAssertFalse(isMarketOpen)
    }
    
    func testMarketIsClosedOnSunday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-12T09:30:00")
        let isMarketOpen: Bool = DateHelper.isMarketOpenOnDate(date!)
        XCTAssertFalse(isMarketOpen)
    }

    func testMarketIsClosedOnHoliday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-03T09:30:00")
        let isMarketOpen: Bool = DateHelper.isMarketOpenOnDate(date!)
        XCTAssertFalse(isMarketOpen)
    }
    
    func testNextDayOfTrade() {
        let date: NSDate? = utcFormatter!.dateFromString("2015-07-09T04:29:00")
        let dayOfTrade: String? = DateHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-09", dayOfTrade!)
    }
    
    func testNextDayOfTradeBeforeOpen() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-09T08:59:59")
        let dayOfTrade: String? = DateHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-09", dayOfTrade!)
    }
    
    func testNextDayOfTradeAfterOpen() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-09T09:00:00")
        let dayOfTrade: String? = DateHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-10", dayOfTrade!)
    }
    
}
