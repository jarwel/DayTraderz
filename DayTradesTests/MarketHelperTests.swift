//
//  MarketHelperTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class MarketHelperTests: XCTestCase {
    
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
    
    func testIsMarketOpen() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-06T09:30:00")
        let isMarketOpen: Bool = MarketHelper.isMarketOpenOnDate(date!)
        XCTAssertTrue(isMarketOpen)
    }
    
    func testIsMarketOpenPreMarket() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-06T09:29:00")
        let isMarketOpen: Bool = MarketHelper.isMarketOpenOnDate(date!)
        XCTAssertFalse(isMarketOpen)
    }
    
    func testIsMarketOpenPostMarket() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-06T16:00:00")
        let isMarketOpen: Bool = MarketHelper.isMarketOpenOnDate(date!)
        XCTAssertFalse(isMarketOpen)
    }
    
    func testIsMarketOpenOnSaturday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-11T10:00:00")
        let isMarketOpen: Bool = MarketHelper.isMarketOpenOnDate(date!)
        XCTAssertFalse(isMarketOpen)
    }
    
    func testIsDayOfTrade() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-06T09:30:00")
        let isDayOfTrade: Bool = MarketHelper.isDayOfTrade(date!)
        XCTAssertTrue(isDayOfTrade)
    }
    
    func testIsDayOfTradeOnSaturday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-11T10:00:00")
        let isDayOfTrade: Bool = MarketHelper.isDayOfTrade(date!)
        XCTAssertFalse(isDayOfTrade)
    }
    
    func testIsDayOfTradeOnSunday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-12T10:00:00")
        let isDayOfTrade: Bool = MarketHelper.isDayOfTrade(date!)
        XCTAssertFalse(isDayOfTrade)
    }

    func testIsDayOfTradeOnHoliday() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-03T10:00:00")
        let isDayOfTrade: Bool = MarketHelper.isDayOfTrade(date!)
        XCTAssertFalse(isDayOfTrade)
    }
    
    func testNextDayOfTrade() {
        let date: NSDate? = utcFormatter!.dateFromString("2015-07-09T04:29:00")
        let dayOfTrade: String = MarketHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-09", dayOfTrade)
    }
    
    func testNextDayOfTrade_2() {
        let date: NSDate? = utcFormatter!.dateFromString("2015-07-12T06:15:00")
        let dayOfTrade: String = MarketHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-13", dayOfTrade)
    }
    
    func testNextDayOfTrade_3() {
        let date: NSDate? = utcFormatter!.dateFromString("2015-07-22T19:14:00")
        let dayOfTrade: String = MarketHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-23", dayOfTrade)
    }
    
    func testNextDayOfTradeBeforeOpen() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-09T08:59:59")
        let dayOfTrade: String = MarketHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-09", dayOfTrade)
    }
    
    func testNextDayOfTradeAfterOpen() {
        let date: NSDate? = easternFormatter!.dateFromString("2015-07-09T09:00:00")
        let dayOfTrade: String = MarketHelper.nextDayOfTradeFromDate(date!)
        XCTAssertEqual("2015-07-10", dayOfTrade)
    }
    
}
