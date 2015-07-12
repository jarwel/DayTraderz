//
//  DayQuote.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class DayQuote {
    
    lazy var symbol: String = self.parseSymbol()
    lazy var date: String = self.parseDate()
    lazy var open: Double = self.parseOpen()
    lazy var close: Double = self.parseClose()
    
    var json: NSDictionary
    
    init(json: NSDictionary) {
        self.json = json
    }
    
    func parseSymbol() -> String {
        if let symbol: AnyObject = json["Symbol"] {
            return symbol as! String
        }
        return ""
    }

    func parseDate() -> String {
        if let date: AnyObject = json["Date"] {
            return date as! String
        }
        return ""
    }
    
    func parseOpen() -> Double {
        if let open: AnyObject = json["Open"] {
            return (open as! NSString).doubleValue
        }
        return 0
    }
    
    func parseClose() -> Double {
        if let close: AnyObject = json["Close"] {
            return (close as! NSString).doubleValue
        }
        return 0
    }
    
    class func fromData(data: NSData) -> DayQuote? {
        let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
        if let query = json["query"] as? NSDictionary {
            if let count = query["count"] as? Int {
                if count == 1 {
                    if let results = query["results"] as? NSDictionary {
                        if let quote = results["quote"] as? NSDictionary {
                            return DayQuote(json: quote)
                        }
                    }
                }
            }
        }
        return nil
    }


    
}