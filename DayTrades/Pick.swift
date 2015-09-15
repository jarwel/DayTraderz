//
//  Pick.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class Pick: PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser;
    @NSManaged var account: Account;
    @NSManaged var symbol: String;
    @NSManaged var dayOfTrade: String;
    @NSManaged var open: Double;
    @NSManaged var close: Double;
    @NSManaged var value: Double;
    @NSManaged var change: Double;
    @NSManaged var processed: Bool;
    
    convenience init(account: Account, symbol: String, dayOfTrade: String) {
        self.init()
        self.user = account.user
        self.account = account
        self.symbol = symbol
        self.dayOfTrade = dayOfTrade
    }
    
    static func parseClassName() -> String {
        return "Pick"
    }
    
}