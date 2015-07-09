//
//  SignUpViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "SignUpViewController.h"
#import "DayTrades-Swift.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-4.jpg"]]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"Sign Up"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:38]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.signUpView setLogo:titleLabel];
    
    
    [self.signUpView.usernameField setBackgroundColor:[UIColor translucentColor]];
    [self.signUpView.usernameField setTextColor:[UIColor whiteColor]];
    [self.signUpView.passwordField setBackgroundColor:[UIColor translucentColor]];
    [self.signUpView.passwordField setTextColor:[UIColor whiteColor]];
    [self.signUpView.emailField setBackgroundColor:[UIColor translucentColor]];
    [self.signUpView.emailField setTextColor:[UIColor whiteColor]];
    
    [self.signUpView.signUpButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.signUpView.usernameField setText:nil];
    [self.signUpView.emailField setText:nil];
    [self.signUpView.passwordField setText: nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self adjustFrameForView:self.signUpView.logo];
    [self adjustFrameForView:self.signUpView.usernameField];
    [self adjustFrameForView:self.signUpView.passwordField];
    [self adjustFrameForView:self.signUpView.emailField];
    [self adjustFrameForView:self.signUpView.signUpButton];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField != self.signUpView.emailField) {
        return !([textField.text length] >= 15 && [string length] > range.length);
    }
    return YES;
}

- (void)adjustFrameForView:(UIView *)view {
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y - 25, view.frame.size.width, view.frame.size.height)];
}

- (void)textWillChange:(id<UITextInput>)textInput {}
- (void)textDidChange:(id<UITextInput>)textInput {}
- (void)selectionWillChange:(id<UITextInput>)textInput {}
- (void)selectionDidChange:(id<UITextInput>)textInput {}

@end
