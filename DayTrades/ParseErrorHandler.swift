//
//  ParseErrorHandler.swift
//  DayTrades
//
//  Created by Jason Wells on 7/16/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class ParseErrorHandler {
    
    static func handleError(error: NSError?) {
        if (error == nil || !(error!.domain == PFParseErrorDomain)) {
            return
        }
        
        switch error!.code {
        case PFErrorCode.ErrorInvalidSessionToken.rawValue:
            handleInvalidSessionTokenError()
        default:
            print("missing error handler for error code \(error!.code)")
        }
    }
    
    static func handleInvalidSessionTokenError() {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogOut.rawValue, object: nil)
    }
    
    static func handleErrorWithBlock(block: ([AnyObject]?, NSError?) -> Void) -> PFQueryArrayResultBlock? {
        return { (objects: [PFObject]?, error: NSError?) -> Void in
            ParseErrorHandler.handleError(error)
            block(objects, error)
        }
    }
    
    static func handleErrorWithBlock(block: (PFObject?, NSError?) -> Void) -> PFObjectResultBlock? {
        return { (object: PFObject?, error: NSError?) -> Void in
            ParseErrorHandler.handleError(error)
            block(object, error)
        }
    }
    
    static func handleErrorWithBlock(block: (Bool, NSError?) -> Void) -> PFBooleanResultBlock? {
        return { (succeeded: Bool, error: NSError?) -> Void in
            ParseErrorHandler.handleError(error)
            block(succeeded, error)
        }
    }
    
}
