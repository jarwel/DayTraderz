//
//  ParseClient.swift
//  DayTrades
//
//  Created by Jason Wells on 7/12/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ParseClient {
    
    class func createAccount(block: (Bool, NSError?) -> Void ) {
        if let user: PFUser = PFUser.currentUser() {
            let account: Account = Account(user: user)
            account.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
        }
        else {
            print("current user is missing")
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
            print("current user is missing")
        }
    }
    
    class func fetchAccountsSortedByValue(limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        let query: PFQuery? = Account.query()
        query?.includeKey("user")
        query?.whereKey("picks", greaterThan: 0)
        query?.limit = limit
        query?.skip = skip
        query?.orderByDescending("value")
        query?.addDescendingOrder("winners")
        query?.addAscendingOrder("losers")
        query?.findObjectsInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
    class func fetchAccountsSortedByWinners(limit: Int, skip: Int, block: ([AnyObject]?, NSError?) -> Void) {
        let query: PFQuery? = Account.query()
        query?.includeKey("user")
        query?.whereKey("picks", greaterThan: 0)
        query?.limit = limit
        query?.skip = skip
        query?.orderByDescending("winners")
        query?.addAscendingOrder("losers")
        query?.addDescendingOrder("value")
        query?.findObjectsInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
    class func refreshAccount(account: Account, block: (object: PFObject?, error: NSError?) -> Void ) {
        account.fetchInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
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
    
    class func setNextPick(symbol: String, block: (Bool, NSError?) -> Void) {
        fetchAccount { (object: PFObject?, error: NSError?) -> Void in
            if let account: Account = object as? Account {
                let dayOfTrade: String = MarketHelper.nextDayOfTrade()
                self.fetchNextPick({ (object: PFObject?, error: NSError?) -> Void in
                    if let nextPick: Pick = object as? Pick {
                        nextPick.symbol = symbol
                        nextPick.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
                    }
                    else {
                        let nextPick: Pick = Pick(account: account, symbol: symbol, dayOfTrade: dayOfTrade)
                        nextPick.saveInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
                    }
                })
            }
        }
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
            print("user is missing")
        }
    }
    
    class func deletePick(pick: Pick, block: (Bool, NSError?) -> Void) {
        pick.deleteInBackgroundWithBlock(ParseErrorHandler.handleErrorWithBlock(block))
    }
    
}
