//
//  Stock.swift
//  DayTrades
//
//  Created by Jason Wells on 7/17/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class Stock: PFObject, PFSubclassing {
    
    @NSManaged var symbol: String;
    @NSManaged var name: String?;
    @NSManaged var picks: UInt;
    
    class func parseClassName() -> String {
        return "Stock"
    }
}
