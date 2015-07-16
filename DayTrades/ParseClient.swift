//
//  ParseClient.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ParseClient {
    
    class func createAccount(block: (Bool, NSError?) -> Void ){
        if let user: PFUser = PFUser.currentUser() {
            let account: Account = Account(user: user)
            account.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
        }
        else {
            println("user is missing")
            block(false, NSError())
        }
    }
    
   
    class func fetchAccount(block: (PFObject?, NSError?) -> Void ) {
        if let user: PFUser = PFUser.currentUser() {
            let query: PFQuery? = Account.query()
            query?.includeKey("user")
            query?.whereKey("user", equalTo: user)
            query?.getFirstObjectInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block));
        }
        else {
            println("user is missing")
            block(nil, NSError())
        }
    }
    
    class func refreshAccount(account: Account, block: (object: PFObject?, error: NSError?) -> Void ) {
        account.fetchInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
    class func fetchPicksForAccount(account: Account, limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void ) {
        let query: PFQuery? = Pick.query()
        query?.includeKey("account")
        query?.whereKey("account", equalTo: account)
        query?.orderByDescending("dayOfTrade")
        query?.limit = limit
        query?.skip = skip
        query?.findObjectsInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
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
            query?.findObjectsInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
        }
    }
    
    class func createOrUpdatePick(pick: Pick, block: (Bool, NSError?) -> Void) {
        let query: PFQuery? = Pick.query()
        query?.whereKey("account", equalTo: pick.account)
        query?.whereKey("dayOfTrade", equalTo: pick.dayOfTrade)
        query?.getFirstObjectInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            ParseErrorHandler.handleError(error)
            if object == nil {
                pick.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
            }
            else {
                object?.deleteInBackgroundWithBlock({ (succeeded: Bool, error: NSError?) -> Void in
                    if succeeded && error == nil {
                        pick.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
                    }
                    else {
                        println("Error \(error) \(error!.userInfo)")
                    }
                })
            }
        })
    }
    
    class func deletePick(pick: Pick, block: (Bool, NSError?) -> Void) {
        pick.deleteInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
}
