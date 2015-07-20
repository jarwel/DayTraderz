//
//  PickViewControllerTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/19/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class PickViewContollerTests: XCTestCase {
    
    var pickViewController: PickViewController?
    
    override func setUp() {
        super.setUp()
        pickViewController = PickViewController()
    }
    
    override func tearDown() {
        pickViewController = nil
        super.tearDown()
    }
    
    func testIsValidSymbol() {
        let symbol: String = "AAPL"
        let isValid: Bool = pickViewController!.isValidSymbol(symbol)
        XCTAssertTrue(isValid)
    }
    
    func testIsValidSymbolLowercase() {
        let symbol: String = "aapl"
        let isValid: Bool = pickViewController!.isValidSymbol(symbol)
        XCTAssertTrue(isValid)
    }
    
    func testIsValidMarket() {
        let symbol: String = "^GSPC"
        let isValid: Bool = pickViewController!.isValidSymbol(symbol)
        XCTAssertFalse(isValid)
    }
    
    func testIsValidDisabledGRNBF() {
        let symbol: String = "GRNBF"
        let isValid: Bool = pickViewController!.isValidSymbol(symbol)
        XCTAssertFalse(isValid)
    }
    
}
