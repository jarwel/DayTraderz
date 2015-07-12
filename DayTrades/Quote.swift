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
        if let symbol: AnyObject = json["symbol"] {
            return symbol as! String
        }
        return ""
    }
    
    func parseName() -> String {
        if let name: AnyObject = json["Name"] {
            return name as! String
        }
        return ""
    }
    
    func parseOpen() -> Double {
        if let open: AnyObject = json["Open"] {
            return (open as! NSString).doubleValue
        }
        return 0
    }
    
    func parsePrice() -> Double {
        if let price: AnyObject = json["LastTradePriceOnly"] {
            return (price as! NSString).doubleValue
        }
        return 0
    }
    
    func parsePriceChange() -> Double {
        if let priceChange: AnyObject = json["Change"] {
            return (priceChange as! NSString).doubleValue
        }
        return 0
    }
    
    func parsePercentChange() -> Double {
        if let percentChange: AnyObject = json["ChangeinPercent"] {
            return (percentChange as! NSString).doubleValue
        }
        return 0
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
                        for object: AnyObject in results {
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