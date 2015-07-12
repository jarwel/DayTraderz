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
    
    static func newForUser(user: PFUser) -> Account {
        let account: Account = Account()
        account.user = user
        account.value = 10000.00
        account.winners = 0
        account.losers = 0
        return account
    }
    
    class func parseClassName() -> String {
        return "Account"
    }
    
}

