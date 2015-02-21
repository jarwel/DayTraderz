//
//  SignUpViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setText:@"DayTrades"];
    [self.titleLabel setTextColor:[UIColor lightGrayColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:40]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.signUpView.logo addSubview:self.titleLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    self.signUpView.usernameField.text = nil;
    self.signUpView.emailField.text = nil;
    self.signUpView.passwordField.text = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    float logoWidth = self.signUpView.usernameField.frame.origin.y * 0.6f;
    float logoX = (self.view.frame.size.width / 2) - (logoWidth / 2);
    float logoY = (self.signUpView.usernameField.frame.origin.y / 2) - (logoWidth / 2);
    [self.signUpView.logo setFrame:CGRectMake(logoX, logoY, logoWidth, logoWidth)];
    
    float titleWidth = logoWidth * 0.9f;
    float titleHeight = logoWidth / 3;
    float titleX = (logoWidth / 2) - (titleWidth / 2);
    float titleY = logoWidth - titleHeight;
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.titleLabel setFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.signUpView.usernameField) {
        return !([textField.text length] >= 15 && [string length] > range.length);
    }
    return YES;
}

@end
