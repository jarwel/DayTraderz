//
//  PickViewController.m
//  DayTraderz
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
    [self setTitle:[NSString stringWithFormat:@"Trade %@", [[DateHelper instance] tradeDateFormat:self.tradeDate]]];
    
    NSString *details = @"The security listed above will be bought for the full value of your account at the opening price and sold at market close on the next trading day %@.";
    self.detailsLabel.text = [NSString stringWithFormat:details, [[DateHelper instance] tradeDateFormat:self.tradeDate]];
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
        self.changeLabel.text = [PriceFormatter changeFormatFromQuote:self.quote];
        self.changeLabel.textColor = [PriceFormatter colorFromChange:self.quote.priceChange];
        [self.confirmButton setEnabled:YES];
    }
    else {
        self.symbolLabel.text = @"";
        self.nameLabel.text = @"";
        self.priceLabel.text = @"";
        self.changeLabel.text = @"";
        [self.confirmButton setEnabled:NO];
    }
}

- (IBAction)onConfirmButtonTouched:(id)sender {
    if (self.quote) {
        NSString *symbol = self.quote.symbol;
        NSDate *tradeDate = [[DateHelper instance] nextTradeDate];
        Pick *pick = [[Pick alloc] initForAccount:self.account withSymbol:symbol withDate:tradeDate];
        [pick saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.delegate pickFromController:pick];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

@end
