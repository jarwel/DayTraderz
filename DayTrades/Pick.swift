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
    
    static func newForAccount(account: Account, symbol: String, dayOfTrade: String ) -> Pick {
        let pick: Pick = Pick()
        pick.account = account
        pick.user = account.user;
        pick.symbol = symbol;
        pick.dayOfTrade = dayOfTrade;
        return pick
    }
    
    class func parseClassName() -> String {
        return "Pick"
    }
    
}