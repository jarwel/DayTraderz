//
//  LogInViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "LogInViewController.h"
#import "UIColor+Application.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-4.jpg"]]];

    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"DayTrades"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:38]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.logInView setLogo:titleLabel];
    
    [self.logInView.usernameField setBackgroundColor:[UIColor translucentColor]];
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.passwordField setBackgroundColor:[UIColor translucentColor]];
    [self.logInView.passwordField setTextColor:[UIColor whiteColor]];
    
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.logInView.dismissButton setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.logInView.usernameField setText:nil];
    [self.logInView.passwordField setText:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

@end
