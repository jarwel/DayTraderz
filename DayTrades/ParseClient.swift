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
            println("current user is missing")
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
            println("current user is missing")
            block(nil, NSError())
        }
    }
    
    class func refreshAccount(account: Account, block: (object: PFObject?, error: NSError?) -> Void ) {
        account.fetchInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
    class func fetchAccountsSortedByValue(limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        fetchAccountsSortedByColumns("value,winners,losers", limit: limit, skip: skip, block: block)
    }
    
    class func fetchAccountsSortedByWinners(limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        fetchAccountsSortedByColumns("winners,losers,value", limit: limit, skip: skip, block: block)
    }
    
    class func fetchStockForSymbol(symbol: String, block: (PFObject?, NSError?) -> Void ) {
        let query: PFQuery? = Stock.query()
        query?.whereKey("symbol", equalTo: symbol)
        query?.getFirstObjectInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block));
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
    
    class func fetchNextPick(block: (PFObject?, NSError?) -> Void ) {
        let dayOfTrade: String = MarketHelper.nextDayOfTrade()
        if let user: PFUser = PFUser.currentUser() {
            let query: PFQuery? = Pick.query()
            query?.whereKey("user", equalTo: user)
            query?.whereKey("dayOfTrade", equalTo: dayOfTrade)
            query?.getFirstObjectInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block));
        }
        else {
            println("user is missing")
            block(nil, NSError())
        }
    }
    
    class func setNextPick(symbol: String, block: (Bool, NSError?) -> Void) {
        fetchAccount { (object: PFObject?, error: NSError?) -> Void in
            if let account: Account = object as? Account {
                let dayOfTrade: String = MarketHelper.nextDayOfTrade()
                let nextPick: Pick = Pick(account: account, symbol: symbol, dayOfTrade: dayOfTrade)
                self.fetchNextPick({ (object: PFObject?, error: NSError?) -> Void in
                    if let oldPick: Pick = object as? Pick {
                        self.deletePick(oldPick, block: { (succeeded: Bool, error: NSError?) -> Void in
                            if succeeded {
                                nextPick.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
                            }
                        })
                    }
                    nextPick.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
                })
            }
        }
    }
    
    class func deletePick(pick: Pick, block: (Bool, NSError?) -> Void) {
        pick.deleteInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
    private class func fetchAccountsSortedByColumns(columns: String, limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        let hasWinnersQuery: PFQuery? = Account.query()
        hasWinnersQuery?.whereKey("winners", greaterThan: 0)
        
        let hasLosersQuery: PFQuery? = Account.query()!
        hasLosersQuery?.whereKey("losers", greaterThan: 0)
        
        let query: PFQuery? = PFQuery.orQueryWithSubqueries([hasWinnersQuery!, hasLosersQuery!])
        query?.includeKey("user")
        query?.orderByDescending(columns)
        query?.limit = limit
        query?.skip = skip
        query?.findObjectsInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
}
