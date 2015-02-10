//
//  AccountViewController.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AccountViewController.h"
#import "AppConstants.h"
#import "ParseClient.h"
#import "FinanceClient.h"
#import "PicksViewController.h"
#import "Account.h"
#import "Quote.h"
#import "PickCell.h"
#import "DateHelper.h"
#import "PriceFormatter.h"

@interface AccountViewController () <PicksViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextPickLabel;

@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) Pick *nextPick;
@property (strong, nonatomic) Pick *currentPick;
@property (strong, nonatomic) NSMutableArray *picks;
@property (strong, nonatomic) Quote *quote;
@property (strong, nonatomic) NSTimer *quoteTimer;

- (void)refreshQuote;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picks = [[NSMutableArray alloc] init];
    self.quoteTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshQuote) userInfo:nil repeats:YES];

    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    
    [[ParseClient instance] fetchAccountForUser:PFUser.currentUser callback:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.account = objects[0];
            [[ParseClient instance] fetchPicksForAccount:self.account callback:^(NSArray *objects, NSError *error) {
                if (!error) {
                    [self refreshPicks:objects];
                }
            }];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Current";
    }
    return @"Past";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.picks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0 && self.currentPick) {
        cell.dateLabel.text = [DateHelper formattedTradeDate:self.currentPick.tradeDate];
        cell.symbolLabel.text = self.currentPick.symbol;
        cell.buyLabel.text = [NSString stringWithFormat:@"%0.02f Buy", self.quote.open];
        cell.sellLabel.text = @"--";
        cell.changeLabel.text = [PriceFormatter formattedChangeFromQuote:self.quote];
        cell.changeLabel.textColor = [PriceFormatter colorForChange:self.quote.priceChange];
    }
    
    if (indexPath.section == 1) {
        Pick* pick = [self.picks objectAtIndex:indexPath.row];
        cell.dateLabel.text = [DateHelper formattedTradeDate:pick.tradeDate];
        cell.symbolLabel.text = pick.symbol;
        
        cell.buyLabel.text = [NSString stringWithFormat:@"%0.02f Buy", pick.open];
        cell.sellLabel.text = [NSString stringWithFormat:@"%0.02f Sell", pick.close];
        cell.changeLabel.text = [PriceFormatter formattedChangeFromPick:pick];
        cell.valueLabel.text = [NSString stringWithFormat:@"$%0.02f", pick.value + pick.change];
        cell.changeLabel.textColor = [PriceFormatter colorForChange:pick.change];
    }
    
    return cell;
}

- (void)pickFromController:(Pick *)pick {
    self.nextPick = pick;
    [self refreshViews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPicksSegue"]) {
        PicksViewController *picksViewController = segue.destinationViewController;
        picksViewController.delegate = self;
        picksViewController.account = self.account;
    }
}

- (void)refreshViews {
    self.valueLabel.text = [NSString stringWithFormat:@"$%0.02f", self.account.value];
    self.nextPickLabel.text = [NSString stringWithFormat:@"Next Pick: %@", self.nextPick.symbol];
    [self.tableView reloadData];
}

- (void)refreshQuote {
    if (self.currentPick) {
    NSSet *symbols = [NSSet setWithObjects:self.currentPick.symbol, nil];
        [[FinanceClient instance] fetchQuotesForSymbols:symbols callback:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (!error) {
                NSArray *quotes = [Quote fromData:data];
                if (quotes.count == 1) {
                    self.quote = [quotes firstObject];
                    [self refreshViews];
                }
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)refreshPicks:(NSArray *)objects {
    NSMutableArray *newPicks = [[NSMutableArray alloc] init];
    for (Pick* pick in objects) {
        if ([self isNextPick:pick]) {
            self.nextPick = pick;
        }
        else if ([self isCurrentPick:pick]) {
            self.currentPick = pick;
        }
        else {
            [newPicks addObject:pick];
        }
    }
    self.picks = newPicks;
    [self refreshViews];
}

- (IBAction)onLogOutButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
}

- (BOOL)isCurrentPick:(Pick *) pick {
    if (pick) {
        NSDate *lastTradeDate = [DateHelper lastTradeDate];
        if ([lastTradeDate compare:pick.tradeDate] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isNextPick:(Pick *) pick {
    if (pick) {
        NSDate *nextTradeDate = [DateHelper nextTradeDate];
        if ([nextTradeDate compare:pick.tradeDate] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

@end
