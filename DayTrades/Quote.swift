//
//  Quote.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class Quote: NSObject {
    
    lazy var symbol: String = self.parseSymbol()
    lazy var name: String = self.parseName()
    lazy var open: Double = self.parseOpen()
    lazy var price: Double = self.parsePrice()
    lazy var priceChange: Double = self.parsePriceChange()
    lazy var percentChange: Double = self.parsePercentChange()
    
    var json: NSDictionary
    
    init(json: NSDictionary) {
        self.json = json
    }
    
    func parseSymbol() -> String {
        return json["symbol"] as! String
    }
    
    func parseName() -> String {
        return json["Name"] as! String
    }
    
    func parseOpen() -> Double {
        let open: String = json["Open"] as! String
        return (open as NSString).doubleValue
    }
    
    func parsePrice() -> Double {
        let price: String = json["LastTradePriceOnly"] as! String
        return (price as NSString).doubleValue
    }
    
    func parsePriceChange() -> Double {
        let priceChange: String = json["Change"] as! String
        return (priceChange as NSString).doubleValue
    }
    
    func parsePercentChange() -> Double {
        let percentChange: String = json["ChangeinPercent"] as! String
        return (percentChange as NSString).doubleValue
    }
    
    class func fromData(data: NSData) -> Array<Quote> {
        var quotes: Array<Quote> = Array()
        let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
        if let query = json["query"] as? NSDictionary {
            if let count = query["count"] as? Int {
                if count == 1 {
                    if let results = query["results"] as? NSDictionary {
                        if let quote = results["quote"] as? NSDictionary {
                            quotes.append(Quote(json: quote))
                        }
                    }
                }
                if count > 1 {
                    if let results = query["results"] as? NSArray {
                        for object : AnyObject in results {
                            if let quote = object as? NSDictionary {
                                quotes.append(Quote(json: quote))
                            }
                        }
                    }
                }
            }
        }
        return quotes
    }
    
}