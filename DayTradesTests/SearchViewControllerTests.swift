//
//  SearchViewControllerTests.swift
//  DayTrades
//
//  Created by Jason Wells on 7/19/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import XCTest

class SearchViewContollerTests: XCTestCase {
    
    var searchViewController: SearchViewController?
    
    override func setUp() {
        super.setUp()
        searchViewController = SearchViewController()
    }
    
    override func tearDown() {
        searchViewController = nil
        super.tearDown()
    }
    
    func testIsValidSymbol() {
        let symbol: String = "AAPL"
        let isValid: Bool = searchViewController!.isValidSymbol(symbol)
        XCTAssertTrue(isValid)
    }
    
    func testIsValidSymbolLowercase() {
        let symbol: String = "aapl"
        let isValid: Bool = searchViewController!.isValidSymbol(symbol)
        XCTAssertTrue(isValid)
    }
    
    func testIsValidMarket() {
        let symbol: String = "^GSPC"
        let isValid: Bool = searchViewController!.isValidSymbol(symbol)
        XCTAssertFalse(isValid)
    }
    
    func testIsValidDisabledGRNBF() {
        let symbol: String = "GRNBF"
        let isValid: Bool = searchViewController!.isValidSymbol(symbol)
        XCTAssertFalse(isValid)
    }
    
}
