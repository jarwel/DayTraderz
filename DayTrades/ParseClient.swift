//
//  ParseClient.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
  
    class func fetchAccountForUser(user: PFUser, block: (PFObject?, NSError?) -> Void ) {
        if let query: PFQuery = Account.query() {
            query.includeKey("user")
            query.whereKey("user", equalTo: user)
            query.getFirstObjectInBackgroundWithBlock(block)
        }
    }
    
    class func fetchPicksForAccount(account: Account, limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void ) {
        if let query: PFQuery = Pick.query() {
            query.includeKey("account")
            query.whereKey("account", equalTo: account)
            query.orderByDescending("dayOfTrade")
            query.limit = limit
            query.skip = skip
            query.findObjectsInBackgroundWithBlock(block)
        }
    }
    
    class func fetchAccountsSortedByColumn(column: String, limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        if let query: PFQuery = Account.query() {
            query.includeKey("user")
            query.orderByDescending(column)
            query.limit = limit
            query.skip = skip
            query.findObjectsInBackgroundWithBlock(block)
        }
    }
    
    class func createOrUpdatePick(pick: Pick) {
        if let query: PFQuery = Pick.query() {
            query.whereKey("account", equalTo: pick.account)
            query.whereKey("dayOfTrade", equalTo: pick.dayOfTrade)
            query.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    if object == nil {
                        pick.saveInBackgroundWithBlock(nil)
                    }
                    else {
                        object?.deleteInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                            if succeeded && error == nil {
                                pick.saveInBackgroundWithBlock(nil)
                            }
                        })
                    }
                }
            })
        }
    }
    
}
