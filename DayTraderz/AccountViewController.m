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
@property (weak, nonatomic) IBOutlet UILabel *totalPicksLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPicksLabel;
@property (weak, nonatomic) IBOutlet UILabel *badPicksLabel;
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

- (void)viewDidDisappear:(BOOL)animated {
    [self.quoteTimer invalidate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Current Pick";
    }
    return @"Historical";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.picks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell resetSubviews];
    
    if (indexPath.section == 0 && !self.currentPick.processed) {
        cell.dateLabel.text = [DateHelper tradeDateFormat:self.currentPick.tradeDate];
        cell.symbolLabel.text = self.currentPick.symbol;
        if (self.quote.open != 0) {
            float estimatedPriceChange =  self.quote.price - self.quote.open;
            float estimatedPercentChange = estimatedPriceChange / self.quote.open;
            float estimatedValue = self.account.value + (self.account.value * estimatedPercentChange);
            cell.buyLabel.text = [NSString stringWithFormat:@"Buy: %0.02f", self.quote.open];
            cell.valueLabel.text = [NSString stringWithFormat:@"%@ (Est.)", [PriceFormatter valueFormat:estimatedValue]];
            cell.changeLabel.text = [PriceFormatter changeFormat:estimatedPriceChange percentChange:estimatedPercentChange];
            cell.changeLabel.textColor = [PriceFormatter colorFromChange:estimatedPriceChange];
        }
    }
    else {
        Pick *pick;
        if (indexPath.section == 0) {
            pick = self.currentPick;
        }
        if (indexPath.section == 1) {
            pick = [self.picks objectAtIndex:indexPath.row];
        }
        cell.dateLabel.text = [DateHelper tradeDateFormat:pick.tradeDate];
        cell.symbolLabel.text = pick.symbol;
        cell.buyLabel.text = [NSString stringWithFormat:@"Buy: %0.02f", pick.open];
        cell.sellLabel.text = [NSString stringWithFormat:@"Sell: %0.02f", pick.close];
        cell.valueLabel.text = [PriceFormatter valueFormat:pick.value + pick.change];
        cell.changeLabel.text = [PriceFormatter changeFormatFromPick:pick];
        cell.changeLabel.textColor = [PriceFormatter colorFromChange:pick.change];
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
    self.nameLabel.text = self.account.user.username;
    self.valueLabel.text = [PriceFormatter valueFormat:self.account.value];
    self.totalPicksLabel.text = [NSString stringWithFormat:@"%d Picks", self.account.goodPicks + self.account.badPicks];
    self.goodPicksLabel.text = [NSString stringWithFormat:@"+%d", self.account.goodPicks];
    self.goodPicksLabel.textColor = [UIColor greenColor];
    self.badPicksLabel.text = [NSString stringWithFormat:@"-%d", self.account.badPicks];
    self.badPicksLabel.textColor = [UIColor redColor];
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
