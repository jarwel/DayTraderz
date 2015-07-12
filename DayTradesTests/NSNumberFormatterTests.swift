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
    
    func testCurrencyFromNumber() {
        let number: NSNumber = 10000.5
        let string: String = numberFormatter!.currencyFromNumber(number)
        XCTAssertEqual("$10,000.50", string)
    }
    
    func testPriceFromNumber() {
        let number: NSNumber = 0.5
        let string: String = numberFormatter!.priceFromNumber(number)
        XCTAssertEqual("0.50", string)
    }
    
    func testPriceChangeFromNumber() {
        let number: NSNumber = +0.5
        let string: String = numberFormatter!.priceChangeFromNumber(number)
        XCTAssertEqual("+0.50", string)
    }
    
    func testPercentChangeFromNumber() {
        let number: NSNumber = 0.5
        let string: String = numberFormatter!.percentChangeFromNumber(number)
        XCTAssertEqual("+0.50%", string)
    }
    
}