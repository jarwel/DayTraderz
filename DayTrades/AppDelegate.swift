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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        Parse.setApplicationId("nejKNcGGrt7CFNrKoQm0rdRmGWju7LzY7mp6HI5M", clientKey: "lK3DnrFO0M5oo4iNVvSafci6mh0vSZTjm5B3HdnO")
        Account.registerSubclass()
        Pick.registerSubclass()
        Stock.registerSubclass()
        
        window?.rootViewController = currentController()
        if PFUser.currentUser() != nil {
            logIn();
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("logIn"), name: Notification.LogIn.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("logOut"), name: Notification.LogOut.rawValue, object: nil)
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
    
    func currentController() -> UIViewController {
        if PFUser.currentUser() != nil {
            return menuController();
        }
        return logInController();
    }
    
    func menuController() -> UIViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuContoller: UIViewController = storyboard.instantiateViewControllerWithIdentifier("MenuController") 
        return menuContoller;
    }
    
    func logIn() {
        window?.rootViewController = currentController()
    }
    
    func logOut() {
        PFUser.logOut()
        window?.rootViewController = currentController()
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if username.characters.count > 0 && password.characters.count > 0 {
            return true
        }
        let title: String = "Log In Error"
        let message: String = "Please fill out all of the information."
        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "Ok").show()
        return false
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        var informationComplete: Bool = true
        for value: AnyObject in info.values {
            if let string: String = value as? String {
                if string.characters.count < 1 {
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
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogIn.rawValue, object: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        ParseClient.createAccount { (succeeded: Bool, error: NSError?) -> Void in
            if succeeded {
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.LogIn.rawValue, object: nil)
            }
        }
    }

}
