//
//  NSNumberFormatterTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/11/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class NSNumberFormatterTests: XCTestCase {
    
    var numberFormatter: NSNumberFormatter?
    
    override func setUp() {
        super.setUp()
        numberFormatter = NSNumberFormatter()
    }
    
    override func tearDown() {
        numberFormatter = nil
        super.tearDown()
    }
    
    func testUSDFromDouble() {
        let value: Double = 10000.00
        let string: String? = numberFormatter?.USDFromDouble(value)
        XCTAssertEqual("$10,000.00", string!)
    }
    
}