//
//  SettingsViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/23/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.layer.cornerRadius = 4
    }
    
    @IBAction func onLogOutButtonPressed(sender: AnyObject) {
        PFUser.logOut()
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogOut.description, object: nil)
    }
    
}