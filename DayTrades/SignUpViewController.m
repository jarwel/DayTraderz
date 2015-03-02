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
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[self backgroundImage]]];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:@"Join Us"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:40]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.signUpView setLogo:titleLabel];
    
    
    UIColor *fieldBackgroundColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self.signUpView.usernameField setBackgroundColor:fieldBackgroundColor];
    [self.signUpView.usernameField setTextColor:[UIColor whiteColor]];
    [self.signUpView.passwordField setBackgroundColor:fieldBackgroundColor];
    [self.signUpView.passwordField setTextColor:[UIColor whiteColor]];
    [self.signUpView.emailField setBackgroundColor:fieldBackgroundColor];
    [self.signUpView.emailField setTextColor:[UIColor whiteColor]];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.signUpView.usernameField setText:nil];
    [self.signUpView.emailField setText:nil];
    [self.signUpView.passwordField setText: nil];
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

- (UIImage *)backgroundImage {
    CIImage *image = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"background-4.jpg"]];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter= [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:image forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:1.3] forKey:@"inputContrast"];
    return [UIImage imageWithCGImage:[context createCGImage:filter.outputImage fromRect:filter.outputImage.extent]];
}

- (void)textWillChange:(id<UITextInput>)textInput {}
- (void)textDidChange:(id<UITextInput>)textInput {}
- (void)selectionWillChange:(id<UITextInput>)textInput {}
- (void)selectionDidChange:(id<UITextInput>)textInput {}

@end
