//
//  FinanceClient.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class FinanceClient {

    static func fetchQuoteForSymbol(symbol: String, block: (NSData?, NSURLResponse?, NSError?) -> Void ) {
        let query: String = "select symbol, Name, LastTradePriceOnly, Change, ChangeinPercent, Open from yahoo.finance.quotes where symbol = '\(symbol)' and ErrorIndicationreturnedforsymbolchangedinvalid is not null and MarketCapitalization <> '0'"
        sendRequestWithQuery(query, block: block);
    }
    
    static func fetchDayQuotesForSymbol(symbol: String, start: String, end: String, block: (NSData?, NSURLResponse?, NSError?) -> Void ) {
        let query: String = String(format: "select * from yahoo.finance.historicaldata where symbol = '%@' and startDate = '%@' and endDate = '%@'", symbol, start, end)
        sendRequestWithQuery(query, block: block);
    }
    
    private static func sendRequestWithQuery(query: String, block: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let encoded: String = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let path: String = "https://query.yahooapis.com/v1/public/yql?q=\(encoded)&env=store://datatables.org/alltableswithkeys&format=json"
        let url: NSURL = NSURL(string: path)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                    block(data, response, error)
            })
        }).resume()
    }

}