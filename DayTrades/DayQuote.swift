//
//  DayQuote.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class DayQuote {
    
    lazy var symbol: String? = self.parseSymbol()
    lazy var date: String? = self.parseDate()
    lazy var open: Double = self.parseOpen()
    lazy var close: Double = self.parseClose()
    lazy var high: Double = self.parseHigh()
    lazy var low: Double = self.parseLow()
    
    var json: NSDictionary
    
    init(json: NSDictionary) {
        self.json = json
    }
    
    func parseSymbol() -> String? {
        if let value: AnyObject = json["Symbol"] {
            if !(value is NSNull) {
                return value as? String
            }
        }
        return nil
    }

    func parseDate() -> String? {
        if let value: AnyObject = json["Date"] {
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
    
    func parseClose() -> Double {
        if let value: AnyObject = json["Close"] {
            if !(value is NSNull) {
                return (value as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parseHigh() -> Double {
        if let value: AnyObject = json["High"] {
            if !(value is NSNull) {
                return (value as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parseLow() -> Double {
        if let low: AnyObject = json["Low"] {
            if !(low is NSNull) {
                return (low as! NSString).doubleValue
            }
        }
        return 0
    }
    
    class func fromData(data: NSData) -> Array<DayQuote> {
        var quotes: Array<DayQuote> = Array()
        let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
        if let query = json["query"] as? NSDictionary {
            if let count = query["count"] as? Int {
                if count == 1 {
                    if let results = query["results"] as? NSDictionary {
                        if let object = results["quote"] as? NSDictionary {
                            quotes.append(DayQuote(json: object))
                        }
                    }
                }
                if count > 1 {
                    if let results = query["results"] as? NSDictionary {
                        if let objects = results["quote"] as? NSArray {
                            for object: AnyObject in objects {
                                if let json = object as? NSDictionary {
                                    quotes.append(DayQuote(json: json))
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