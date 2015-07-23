//
//  SignUpViewController.swift
//  DayTrades
//
//  Created by Jason Wells on 7/13/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

import Foundation

class SignUpViewController: PFSignUpViewController, UITextInputDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let backgroundImage: UIImage = UIImage(named: "background-login.jpg") {
            signUpView?.backgroundColor = UIColor(patternImage: backgroundImage)
        }

        let titleLabel: UILabel = UILabel()
        titleLabel.text = "DayTrades"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.shadowColor = UIColor.blackColor()
        titleLabel.shadowOffset = CGSizeMake(1, 1)
        titleLabel.font = UIFont.boldSystemFontOfSize(38)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.adjustsFontSizeToFitWidth = true
        signUpView?.logo = titleLabel
        
        signUpView?.usernameField?.backgroundColor = UIColor.translucentColor()
        signUpView?.usernameField?.textColor = UIColor.whiteColor()
        signUpView?.emailField?.backgroundColor = UIColor.translucentColor()
        signUpView?.emailField?.textColor = UIColor.whiteColor()
        signUpView?.passwordField?.backgroundColor = UIColor.translucentColor()
        signUpView?.passwordField?.textColor = UIColor.whiteColor()
        
        if let image: UIImage = UIImage(named: "close.png") {
            signUpView?.dismissButton?.setImage(image, forState: UIControlState.Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        signUpView?.usernameField?.text = nil
        signUpView?.emailField?.text = nil
        signUpView?.passwordField?.text = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSignUpButton()
        adjustFrameForView(signUpView?.logo)
        adjustFrameForView(signUpView?.usernameField)
        adjustFrameForView(signUpView?.passwordField)
        adjustFrameForView(signUpView?.emailField)
    }
    
    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField != signUpView?.emailField {
            return !(count(textField.text) >= 15 && count(string) > range.length)
        }
        return true
    }
    
    func layoutSignUpButton() {
        let x: CGFloat = signUpView!.signUpButton!.frame.origin.x + 16
        let y: CGFloat = signUpView!.signUpButton!.frame.origin.y - 25
        let width: CGFloat = signUpView!.signUpButton!.frame.width - 32
        let height: CGFloat = signUpView!.signUpButton!.frame.height
        signUpView?.signUpButton?.frame = CGRectMake(x, y, width, height)
        signUpView?.signUpButton?.setTitle("Sign Up", forState: UIControlState.Normal)
        signUpView?.signUpButton?.layer.cornerRadius = 4
        signUpView?.signUpButton?.clipsToBounds = true
    }
    
    func adjustFrameForView(view: UIView?){
        let x: CGFloat = view!.frame.origin.x
        let y: CGFloat = view!.frame.origin.y - 25
        let width: CGFloat = view!.frame.size.width
        let height: CGFloat = view!.frame.size.height
        view!.frame = CGRectMake(x, y, width, height)
    }
    
    func textWillChange(textInput: UITextInput) {}
    func textDidChange(textInput: UITextInput) {}
    func selectionWillChange(textInput: UITextInput) {}
    func selectionDidChange(textInput: UITextInput) {}

}