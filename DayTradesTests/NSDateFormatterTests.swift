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

    func testShortFromDayOfTrade() {
        let string: String? = dateFormatter!.shortFromDayOfTrade("2015-07-09")
        XCTAssertEqual(string!, "Thu, Jul 9");
    }
    
    func testFullFromDayOfTrade() {
        let string: String? = dateFormatter!.fullFromDayOfTrade("2015-07-09")
        XCTAssertEqual(string!, "Thursday, July 9, 2015");
    }
    
}
