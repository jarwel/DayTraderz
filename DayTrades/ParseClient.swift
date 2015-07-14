//
//  ParseClient.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
  
    class func fetchOrCreateAccount() -> Account? {
        if let user: PFUser = PFUser.currentUser() {
            let query: PFQuery? = Account.query()
            query?.includeKey("user")
            query?.whereKey("user", equalTo: user)
            if let object: PFObject? = query?.getFirstObject() {
                return object as! Account?
            }
            else {
                let account: Account = Account(user: user)
                account.save()
                return account
            }
        }
        return nil
    }
    
    class func fetchPicksForAccount(account: Account, limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void ) {
        let query: PFQuery? = Pick.query()
        query?.includeKey("account")
        query?.whereKey("account", equalTo: account)
        query?.orderByDescending("dayOfTrade")
        query?.limit = limit
        query?.skip = skip
        query?.findObjectsInBackgroundWithBlock(block)
    }
    
    class func fetchAccountsSortedByColumn(column: String, limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        let hasWinnersQuery: PFQuery? = Account.query()
        hasWinnersQuery?.whereKey("winners", greaterThan: 0)
            
        let hasLosersQuery: PFQuery? = Account.query()!
        hasLosersQuery?.whereKey("losers", greaterThan: 0)
        
        if hasWinnersQuery != nil && hasLosersQuery != nil {
            let query: PFQuery? = PFQuery.orQueryWithSubqueries([hasWinnersQuery!, hasLosersQuery!])
            query?.includeKey("user")
            query?.orderByDescending("\(column),losers")
            query?.limit = limit
            query?.skip = skip
            query?.findObjectsInBackgroundWithBlock(block)
        }
    }
    
    class func createOrUpdatePick(pick: Pick, block: (Bool, NSError?) -> Void) {
        let query: PFQuery? = Pick.query()
        query?.whereKey("account", equalTo: pick.account)
        query?.whereKey("dayOfTrade", equalTo: pick.dayOfTrade)
        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if object == nil {
                pick.saveInBackgroundWithBlock(block)
            }
            else {
                object?.deleteInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                    if succeeded && error == nil {
                        pick.saveInBackgroundWithBlock(block)
                    }
                    else {
                        println("Error \(error) \(error!.userInfo)")
                    }
                })
            }
        })
    }
    
}
