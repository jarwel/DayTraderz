//
//  NSDateFormatterTest.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class NSDateFormatterTests: XCTestCase {
    
    var dateFormatter: NSDateFormatter?
    
    override func setUp() {
        super.setUp()
        dateFormatter = NSDateFormatter()
    }
    
    override func tearDown() {
        dateFormatter = nil
        super.tearDown()
    }
    
    func testFullTextFromDayOfTrade() {
        let text: String? = dateFormatter!.fullTextFromDayOfTrade("2015-07-09")
        XCTAssertEqual(text!, "Thursday, July 9, 2015");
    }

    func testShortTextFromDayOfTrade() {
        let text: String? = dateFormatter!.pickTextFromDayOfTrade("2015-07-09")
        XCTAssertEqual(text!, "Thu, Jul 9");
    }
    
    func testChartTextFromDayOfTrade() {
        let text: String? = dateFormatter!.pickTextFromDayOfTrade("2015-07-09")
        XCTAssertEqual(text!, "Jul09");
    }
    
}
