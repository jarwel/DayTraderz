//
//  Quote.swift
//  DayTrades
//
//  Created by Jason Wells on 7/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class Quote {
    
    lazy var symbol: String? = self.parseSymbol()
    lazy var name: String? = self.parseName()
    lazy var open: Double = self.parseOpen()
    lazy var price: Double = self.parsePrice()
    lazy var priceChange: Double = self.parsePriceChange()
    lazy var percentChange: Double = self.parsePercentChange()
    
    var json: NSDictionary
    
    init(json: NSDictionary) {
        self.json = json
    }
    
    func parseSymbol() -> String? {
        if let symbol: AnyObject = json["symbol"] {
            if !(symbol is NSNull) {
                return symbol as? String
            }
        }
        return nil
    }
    
    func parseName() -> String? {
        if let name: AnyObject = json["symbol"] {
            if !(name is NSNull) {
                return name as? String
            }
        }
        return nil
    }
    
    func parseOpen() -> Double {
        if let open: AnyObject = json["Open"] {
            if !(open is NSNull) {
                return (open as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parsePrice() -> Double {
        if let price: AnyObject = json["LastTradePriceOnly"] {
            if !(price is NSNull) {
                return (price as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parsePriceChange() -> Double {
        if let priceChange: AnyObject = json["Change"] {
            if !(priceChange is NSNull) {
                return (priceChange as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parsePercentChange() -> Double {
        if let percentChange: AnyObject = json["ChangeinPercent"] {
            if !(percentChange is NSNull) {
                return (percentChange as! NSString).doubleValue
            }
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
                        if let json = results["quote"] as? NSDictionary {
                            quotes.append(Quote(json: json))
                        }
                    }
                }
                if count > 1 {
                    if let results = query["results"] as? NSDictionary {
                        if let objects = results["quote"] as? NSArray {
                            for object: AnyObject in objects {
                                if let json = object as? NSDictionary {
                                    quotes.append(Quote(json: json))
                                }
                            }
                        }
                    }
                }
            }
        }
        return quotes
    }
    
}