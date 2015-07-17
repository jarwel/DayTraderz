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
        if let symbol: AnyObject = json["Symbol"] {
            if !(symbol is NSNull) {
                return symbol as? String
            }
        }
        return nil
    }

    func parseDate() -> String? {
        if let date: AnyObject = json["Date"] {
            if !(date is NSNull) {
                return date as? String
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
    
    func parseClose() -> Double {
        if let open: AnyObject = json["Close"] {
            if !(open is NSNull) {
                return (open as! NSString).doubleValue
            }
        }
        return 0
    }
    
    func parseHigh() -> Double {
        if let high: AnyObject = json["High"] {
            if !(high is NSNull) {
                return (high as! NSString).doubleValue
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