//
//  AppDelegate.swift
//  DayTrades
//
//  Created by Jason Wells on 7/14/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var window: UIWindow?
    var account: Account?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Parse.setApplicationId("nejKNcGGrt7CFNrKoQm0rdRmGWju7LzY7mp6HI5M", clientKey: "lK3DnrFO0M5oo4iNVvSafci6mh0vSZTjm5B3HdnO")
        Account.registerSubclass()
        Pick.registerSubclass()
        
        window?.rootViewController = currentViewController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("logIn"), name: Notification.LogIn.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("logOut"), name: Notification.SignOut.description, object: nil)
        if let user: PFUser = PFUser.currentUser() {
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogIn.description, object: nil)
        }
        return true
    }
    
    func logInController() -> UIViewController {
        let signUpController: SignUpViewController = SignUpViewController()
        signUpController.delegate = self
        let logInController: LogInViewController = LogInViewController()
        logInController.delegate = self
        logInController.signUpController = signUpController
        return logInController
    }
    
    func currentViewController() -> UIViewController {
        if let user: PFUser = PFUser.currentUser() {
            return homeController();
        }
        return logInController();
    }
    
    func homeController() -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("AppController") as! UINavigationController
        let accountController: AccountViewController = navigationController.childViewControllers.first as! AccountViewController
        accountController.account = account;
        return navigationController;
    }
    
    func logIn() {
        ParseClient.fetchAccount { (object: PFObject?, error: NSError?) -> Void in
            if object != nil && error == nil {
                self.account = object as? Account
                self.window?.rootViewController = self.currentViewController()
            }
        }
    }
    
    func logOut() {
        account = nil;
        PFUser.logOut()
        window?.rootViewController = currentViewController()
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if count(username) > 0 && count(password) > 0 {
            return true
        }
        let title: String = "Log In Error"
        let message: String = "Please fill out all of the information."
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok").show()
        return false
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var informationComplete: Bool = true
        for (key: NSObject, value: AnyObject) in info {
            if let string: String? = value as? String {
                if count(string!) < 1 {
                    informationComplete = false
                    break
                }
            }
        }
        if !informationComplete {
            let title: String = "Log In Error"
            let message: String = "Please fill out all of the information."
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok").show()
        }
        return informationComplete;
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogIn.description, object: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        ParseClient.createAccount { (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogIn.description, object: nil)
            }
        }
    }

}
