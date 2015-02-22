//
//  SignUpViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"New Account"];
    [titleLabel setTextColor:[UIColor lightGrayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:40]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.signUpView setLogo:titleLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    self.signUpView.usernameField.text = nil;
    self.signUpView.emailField.text = nil;
    self.signUpView.passwordField.text = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.signUpView.usernameField) {
        return !([textField.text length] >= 15 && [string length] > range.length);
    }
    return YES;
}

- (void)textWillChange:(id<UITextInput>)textInput {}
- (void)textDidChange:(id<UITextInput>)textInput {}
- (void)selectionWillChange:(id<UITextInput>)textInput {}
- (void)selectionDidChange:(id<UITextInput>)textInput {}

@end
