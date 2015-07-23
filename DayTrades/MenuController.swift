//
//  MenuViewContoller.swift
//  DayTrades
//
//  Created by Jason Wells on 7/22/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class MenuController: UITabBarController {
    
    override func viewDidLoad() {
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.translucent = true
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        tabBar.barStyle = UIBarStyle.Black
        tabBar.translucent = true
        tabBar.tintColor = UIColor.whiteColor()
        
        let accountViewController: AccountViewController = viewControllers?.first as! AccountViewController
        ParseClient.fetchAccount { (object: PFObject?, error: NSError?) -> Void in
            if let account: Account = object as? Account {
                accountViewController.account = account
            }
        }
    }

}
