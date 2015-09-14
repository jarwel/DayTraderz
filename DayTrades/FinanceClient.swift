//
//  FinanceClient.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class FinanceClient {

    class func fetchQuoteForSymbol(symbol: String, block: (NSURLResponse?, NSData?, NSError?) -> Void ) {
        let query: String = "select symbol, Name, LastTradePriceOnly, Change, ChangeinPercent, Open from yahoo.finance.quotes where symbol = '\(symbol)' and ErrorIndicationreturnedforsymbolchangedinvalid is not null and MarketCapitalization <> '0'"
        sendRequestWithQuery(query, block: block);
    }
    
    class func fetchDayQuotesForSymbol(symbol: String, start: String, end: String, block: (NSURLResponse?, NSData?, NSError?) -> Void ) {
        let query: String = String(format: "select * from yahoo.finance.historicaldata where symbol = '%@' and startDate = '%@' and endDate = '%@'", symbol, start, end)
        sendRequestWithQuery(query, block: block);
    }
    
    private static func sendRequestWithQuery(query: String, block: (NSURLResponse?, NSData?, NSError?) -> Void) {
        let encoded = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let path: String = String(format: "https://query.yahooapis.com/v1/public/yql?q=%@&env=store://datatables.org/alltableswithkeys&format=json", encoded!)
        if let url = NSURL(string: path) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: block)
        }
    }

}