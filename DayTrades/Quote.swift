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
        if let value: AnyObject = json["symbol"] {
            if !(value is NSNull) {
                return value as? String
            }
        }
        return nil
    }
    
    func parseName() -> String? {
        if let value: AnyObject = json["Name"] {
            if !(value is NSNull) {
                return value as? String
            }
        }
        return nil
    }
    
    func parseOpen() -> Double {
        if let value: AnyObject = json["Open"] {
            if !(value is NSNull) {
                return (value as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parsePrice() -> Double {
        if let value: AnyObject = json["LastTradePriceOnly"] {
            if !(value is NSNull) {
                return (value as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parsePriceChange() -> Double {
        if let value: AnyObject = json["Change"] {
            if !(value is NSNull) {
                return (value as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parsePercentChange() -> Double {
        if let value: AnyObject = json["ChangeinPercent"] {
            if !(value is NSNull) {
                return (value as! NSString).doubleValue
            }
        }
        return 0
    }
    
    static func fromData(data: NSData) -> Array<Quote> {
        var quotes: Array<Quote> = Array()
        let json = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! NSDictionary
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