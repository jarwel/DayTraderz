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

@interface PickViewController ()

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
    self.tradeDate = [[DateHelper instance] nextTradeDate];
    [self setTitle:[[DateHelper instance] dayFormatForDate:self.tradeDate]];
    NSString *details = @"The security above will be purchased in full for the value of your account at the opening price and sold at market close on %@. Your choice can be changed until 9:00 AM EST on the date of trade.";
    self.detailsLabel.text = [NSString stringWithFormat:details, [[DateHelper instance] fullFormatForDate:self.tradeDate]];
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
        self.symbolLabel.text = self.quote.symbol;
        self.nameLabel.text = self.quote.name;
        self.priceLabel.text = [NSString stringWithFormat:@"%0.2f", self.quote.price];
        self.changeLabel.text = [PriceFormatter formatForQuote:self.quote];
        self.changeLabel.textColor = [PriceFormatter colorForChange:self.quote.priceChange];
        [self.confirmButton setEnabled:YES];
        [self.confirmButton setBackgroundColor:self.confirmButton.tintColor];
    }
    else {
        self.symbolLabel.text = nil;
        self.nameLabel.text = nil;
        self.priceLabel.text = nil;
        self.changeLabel.text = nil;
        [self.confirmButton setEnabled:NO];
        [self.confirmButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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
