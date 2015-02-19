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
    
    NSString *title = @"DayTrades";
    UIFont *font = [UIFont systemFontOfSize:32];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.font = font;
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor lightGrayColor];
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
    
    float logoWidth = 180.0f;
    float logoHeight = 180.0f;
    float logoX = (self.view.frame.size.width / 2) - (logoWidth / 2);
    float logoY = (self.logInView.usernameField.frame.origin.y / 2) - (logoHeight / 2);
    [self.logInView.logo setFrame:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
    
    float titleWidth = self.titleLabel.frame.size.width;
    float titleHeight = self.titleLabel.frame.size.height;
    float titleX = (logoWidth - titleWidth) / 2;
    float titleY = logoHeight - titleHeight - 10;
    [self.titleLabel setFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
}

@end
