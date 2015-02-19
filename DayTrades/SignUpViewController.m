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
    
    NSString *title = @"DayTrades";
    UIFont *font = [UIFont systemFontOfSize:32];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.font = font;
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    [self.signUpView.logo addSubview:self.titleLabel];
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
//    
//    NSString *title = @"WeTrade";
//    UIFont *font = [UIFont systemFontOfSize:29];
//    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
//    CGRect frame = CGRectMake(5, 85, size.width, size.height);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:frame];
//    label.font = font;
//    label.text = title;
//    label.textColor = [UIColor lightGrayColor];
//    
//    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
//    [logo addSubview:label];
//    
//    [self.signUpView setLogo:logo];
//    [self.signUpView.usernameField setBackgroundColor:[UIColor darkGrayColor]];
//    [self.signUpView.usernameField setBorderStyle:UITextBorderStyleBezel];
//    [self.signUpView.passwordField setBackgroundColor:[UIColor darkGrayColor]];
//    [self.signUpView.passwordField setBorderStyle:UITextBorderStyleBezel];
//    [self.signUpView.emailField setBackgroundColor:[UIColor darkGrayColor]];
//    [self.signUpView.emailField setBorderStyle:UITextBorderStyleBezel];
//    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
//    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//    [self.signUpView.signUpButton setBackgroundColor:[UIColor blueColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.signUpView.usernameField.text = nil;
    self.signUpView.emailField.text = nil;
    self.signUpView.passwordField.text = nil;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    float logoWidth = 180.0f;
    float logoHeight = 180.0f;
    float logoX = (self.view.frame.size.width / 2) - (logoWidth / 2);
    float logoY = (self.signUpView.usernameField.frame.origin.y / 2) - (logoHeight / 2);
    [self.signUpView.logo setFrame:CGRectMake(logoX, logoY, logoWidth, logoHeight)];
    
    float titleWidth = self.titleLabel.frame.size.width;
    float titleHeight = self.titleLabel.frame.size.height;
    float titleX = (logoWidth - titleWidth) / 2;
    float titleY = logoHeight - titleHeight - 10;
    [self.titleLabel setFrame:CGRectMake(titleX, titleY, titleWidth, titleHeight)];
}

@end
