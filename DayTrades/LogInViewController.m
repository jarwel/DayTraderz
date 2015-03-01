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
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[self backgroundImage]]];
    [self.logInView.dismissButton setHidden:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"DayTrades"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:40]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.logInView setLogo:titleLabel];
    
    UIColor *fieldBackgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self.logInView.usernameField setBackgroundColor:fieldBackgroundColor];
    [self.logInView.usernameField setTextColor:[UIColor whiteColor]];
    [self.logInView.passwordField setBackgroundColor:fieldBackgroundColor];
    [self.logInView.passwordField setTextColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.logInView.usernameField setText:nil];
    [self.logInView.passwordField setText:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (UIImage *)backgroundImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"background-1.jpg"]];
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:0.01] forKey:@"inputBrightness"];
    [filter setValue:[NSNumber numberWithFloat:1] forKey:@"inputContrast"];
    return [UIImage imageWithCGImage:[context createCGImage:filter.outputImage fromRect:filter.outputImage.extent]];
}

@end
