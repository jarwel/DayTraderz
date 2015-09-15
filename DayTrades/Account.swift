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
    @NSManaged var picks: UInt
    @NSManaged var winners: UInt
    @NSManaged var losers: UInt
    
    convenience init(user: PFUser) {
        self.init()
        self.user = user
    }
    
    static func parseClassName() -> String {
        return "Account"
    }
    
}

