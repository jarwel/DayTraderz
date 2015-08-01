//
//  ChangeFormatterTests.swift
//  DayTrades
//
//  Created by Jason Wells on 8/1/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class ChangeFormatterTests: XCTestCase {
    
    var changeFormatter: ChangeFormatter?
    
    override func setUp() {
        super.setUp()
        changeFormatter = ChangeFormatter()
    }
    
    override func tearDown() {
        changeFormatter = nil
        super.tearDown()
    }
    
    func testTextFromChangePositive() {
        let priceChange: Double = 10.5
        let percentChange: Double = 1.5
        let text: String = changeFormatter!.textFromChange(priceChange, percentChange: percentChange)
        XCTAssertEqual(text, "+10.50 (+1.50%)");
    }
    
    func testTextFromChangeNegative() {
        let priceChange: Double = -10.5
        let percentChange: Double = -1.5
        let text: String = changeFormatter!.textFromChange(priceChange, percentChange: percentChange)
        XCTAssertEqual(text, "-10.50 (-1.50%)");
    }
    
}