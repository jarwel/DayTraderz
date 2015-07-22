//
//  LogInViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/13/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class LogInViewController: PFLogInViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-login.jpg") {
            logInView?.backgroundColor = UIColor(patternImage: backgroundImage)
        }

        let titleLabel: UILabel = UILabel()
        titleLabel.text = "DayTrades"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.shadowColor = UIColor.blackColor()
        titleLabel.shadowOffset = CGSizeMake(1, 1)
        titleLabel.font = UIFont.boldSystemFontOfSize(38)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.adjustsFontSizeToFitWidth = true
        logInView?.logo = titleLabel
        
        logInView?.usernameField?.backgroundColor = UIColor.translucentColor()
        logInView?.usernameField?.textColor = UIColor.whiteColor()
        logInView?.passwordField?.backgroundColor = UIColor.translucentColor()
        logInView?.passwordField?.textColor = UIColor.whiteColor()
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logInView?.dismissButton?.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logInView?.usernameField?.text = nil
        logInView?.passwordField?.text = nil
    }
    
}