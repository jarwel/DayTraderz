//
//  PickViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PickViewController.h"
#import "DayTrades-Swift.h"

@interface PickViewController ()

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeDateLabel;
@property (weak, nonatomic) IBOutlet UIView *securityView;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *dayOfTrade;
@property (strong, nonatomic) Quote *quote;

@end

@implementation PickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-2.jpg"]]];
    [self.detailsView setBackgroundColor:[UIColor translucentColor]];
    [self.securityView setBackgroundColor:[UIColor translucentColor]];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dayOfTrade = [MarketHelper nextDayOfTrade];
    [self refreshViews];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [searchBar.text length] + [text length] - range.length <= 5;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText hasPrefix:@"^"]) {
        NSSet *symbols = [[[NSSet alloc] init] setByAddingObject:[searchText uppercaseString]];
        [FinanceClient fetchQuotesForSymbols:symbols block:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.quote = nil;
            if (!error) {
                NSArray *quotes = [Quote fromData:data];
                if (quotes.count == 1) {
                    Quote *quote = [quotes firstObject];
                    if ([quote.symbol isEqualToString:[searchBar.text uppercaseString]]) {
                        self.quote = quote;
                    }
                }
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            [self refreshViews];
        }];
    }
}

- (void)refreshViews {
    static NSString *text = @"The listed security will be purchased for the full value of your account at the opening price and sold at market close on %@.";
    NSString *dateFormat = [self.dateFormatter fullFromDayOfTrade:self.dayOfTrade];
    if (self.quote) {
        NSString *disclaimer = [NSString stringWithFormat:text, dateFormat];
        [self.disclaimerLabel setText:disclaimer];
        [self.symbolLabel setText:self.quote.symbol];
        [self.nameLabel setText:self.quote.name];
        [self.priceLabel setText:[NSString stringWithFormat:@"%0.2f", self.quote.price]];
        [self.changeLabel setText:[ChangeFormatter stringFromQuote:self.quote]];
        [self.changeLabel setTextColor:[UIColor changeColor:self.quote.priceChange]];
        [self.detailsView setHidden:YES];
        [self.securityView setHidden:NO];
    }
    else {
        [self.detailsLabel setText:@"Choose a security to buy on"];
        [self.tradeDateLabel setText:dateFormat];
        [self.detailsView setHidden:NO];
        [self.securityView setHidden:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (IBAction)onConfirmButtonTouched:(id)sender {
    if (self.quote) {
        NSString *symbol = self.quote.symbol;
        NSString *dayOfTrade = [MarketHelper nextDayOfTrade];
        Pick *pick = [Pick newForAccount:self.account symbol:symbol dayOfTrade:dayOfTrade];
        [pick saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.delegate updateNextPick:pick];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

@end
