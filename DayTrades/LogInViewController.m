//
//  LogInViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.logInView.dismissButton setHidden:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"DayTrades"];
    [titleLabel setTextColor:[UIColor lightGrayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:40]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.logInView setLogo:titleLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    self.logInView.usernameField.text = nil;
    self.logInView.passwordField.text = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

@end
