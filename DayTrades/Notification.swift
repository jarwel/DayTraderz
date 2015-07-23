//
//  Notification.swift
//  DayTrades
//
//  Created by Jason Wells on 7/14/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

enum Notification: Printable {
    case LogIn, LogOut, NextPickUpdated
    
    var description : String {
        get {
            switch(self) {
            case LogIn:
                return "LogInNotification"
            case LogOut:
                return "SignOutNotification"
            case NextPickUpdated:
                return "NextPickUpdatedNotification"
            }
        }
    }
    
}
