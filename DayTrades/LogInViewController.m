//
//  LogInViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/10/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.logInView.dismissButton setHidden:YES];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setText:@"DayTrades"];
    [self.titleLabel setTextColor:[UIColor lightGrayColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:40]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.logInView.logo addSubview:self.titleLabel];

//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
//
//    [self.logInView.usernameField setBackgroundColor:[UIColor darkGrayColor]];
//    [self.logInView.usernameField setBorderStyle:UITextBorderStyleBezel];
//    [self.logInView.passwordField setBackgroundColor:[UIColor darkGrayColor]];
//    [self.logInView.passwordField setBorderStyle:UITextBorderStyleBezel];
//    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
//    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.logInButton setBackgroundColor:[UIColor darkGrayColor]];
//    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
//    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.signUpButton setBackgroundColor:[UIColor blueColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.logInView.usernameField.text = nil;
    self.logInView.passwordField.text = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    float logoWidth = self.logInView.usernameField.frame.origin.y * 0.6f;
    float logoX = (self.view.frame.size.width / 2) - (logoWidth / 2);
    float logoY = (self.logInView.usernameField.frame.origin.y / 2) - (logoWidth / 2);
    [self.logInView.logo setFrame:CGRectMake(logoX, logoY, logoWidth, logoWidth)];
    
    float titleWidth = logoWidth * 0.9f;
    float titleHeight = logoWidth / 3;
    float titleX = (logoWidth / 2) - (titleWidth / 2);
    float titleY = logoWidth - titleHeight;
    [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.titleLabel setFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
}

@end
