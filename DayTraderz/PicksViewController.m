//
//  PicksViewController.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PicksViewController.h"
#import "FinanceClient.h"
#import "Quote.h"

@interface PicksViewController ()

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) Quote *quote;

@end

@implementation PicksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSSet *symbols = [[[NSSet alloc] init] setByAddingObject:[searchText uppercaseString]];
    [[FinanceClient instance] fetchQuotesForSymbols:symbols callback:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            NSArray *quotes = [Quote fromData:data];
            if (quotes.count == 1) {
                Quote *quote = [quotes firstObject];
                if ([quote.symbol isEqualToString:[searchBar.text uppercaseString]]) {
                    _quote = quote;
                    [self refreshViews];
                }
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)refreshViews {
    _symbolLabel.text = _quote.symbol;
    _nameLabel.text = _quote.name;
    _priceLabel.text = [NSString stringWithFormat:@"%0.2f", _quote.price];
    _changeLabel.text = [self formatChangeFromQuote:_quote];
}


- (IBAction)onConfirmButton:(id)sender {
    if (_quote) {
        Pick *pick = [Pick initForAccount:_account withSymbol:_quote.symbol];
        pick.date = [self todayWithoutTime];
        [pick saveInBackground];
        [_delegate pickFromController:pick];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)formatChangeFromQuote:(Quote *)quote {
    NSString *priceChangeFormat = [NSString stringWithFormat:@"%+0.2f", quote.priceChange];
    NSString *percentChangeFormat = [NSString stringWithFormat:@"%+0.2f%%", quote.percentChange];
    return [NSString stringWithFormat:@"%@ (%@)", priceChangeFormat, percentChangeFormat];
}

- (NSDate *)todayWithoutTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
}

@end
