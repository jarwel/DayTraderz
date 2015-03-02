//
//  PickViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PickViewController.h"
#import "FinanceClient.h"
#import "ParseClient.h"
#import "Quote.h"
#import "DateHelper.h"
#import "PriceFormatter.h"
#import "UIColor+Application.h"

@interface PickViewController ()

@property (weak, nonatomic) IBOutlet UIView *securityView;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) NSDate *tradeDate;
@property (strong, nonatomic) Quote *quote;

@end

@implementation PickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-2.jpg"]]];
    [self.securityView setBackgroundColor:[UIColor translucentColor]];
    
    self.tradeDate = [[DateHelper instance] nextTradeDate];
    [self refreshViews];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText hasPrefix:@"^"]) {
        NSSet *symbols = [[[NSSet alloc] init] setByAddingObject:[searchText uppercaseString]];
        [[FinanceClient instance] fetchQuotesForSymbols:symbols callback:^(NSURLResponse *response, NSData *data, NSError *error) {
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
    if (self.quote) {
        NSString *details = [NSString stringWithFormat:@"The security above will be purchased in full for the value of your account at the opening price and sold at market close on %@.", [[DateHelper instance] fullFormatForDate:self.tradeDate]];
        [self.detailsLabel setText:details];
        [self.symbolLabel setText:self.quote.symbol];
        [self.nameLabel setText:self.quote.name];
        [self.priceLabel setText:[NSString stringWithFormat:@"%0.2f", self.quote.price]];
        [self.changeLabel setText:[PriceFormatter formatForQuote:self.quote]];
        [self.changeLabel setTextColor:[PriceFormatter colorForChange:self.quote.priceChange]];
        [self.securityView setHidden:NO];
    }
    else {
        [self.securityView setHidden:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (IBAction)onConfirmButtonTouched:(id)sender {
    if (self.quote) {
        NSString *symbol = self.quote.symbol;
        NSDate *tradeDate = [[DateHelper instance] nextTradeDate];
        Pick *pick = [[Pick alloc] initForAccount:self.account withSymbol:symbol withDate:tradeDate];
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
