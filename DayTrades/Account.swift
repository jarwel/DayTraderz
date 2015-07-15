//
//  Account.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class Account: PFObject, PFSubclassing {
    
    @NSManaged var user: PFUser
    @NSManaged var value: Double
    @NSManaged var winners: UInt
    @NSManaged var losers: UInt
    
    convenience init(user: PFUser) {
        self.init()
        self.user = user
        self.value = 10000.00
        self.winners = 0
        self.losers = 0
    }
    
    class func parseClassName() -> String {
        return "Account"
    }
    
}

