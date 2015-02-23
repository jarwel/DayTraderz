//
//  AccountViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AccountViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "AppConstants.h"
#import "ParseClient.h"
#import "FinanceClient.h"
#import "PickViewController.h"
#import "Account.h"
#import "Quote.h"
#import "PickCell.h"
#import "DateHelper.h"
#import "PriceFormatter.h"

@interface AccountViewController () <PickViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *picksLabel;
@property (weak, nonatomic) IBOutlet UILabel *winnersLabel;
@property (weak, nonatomic) IBOutlet UILabel *losersLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextPickLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextPickButton;

@property (strong, nonatomic) NSMutableArray *picks;
@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) Pick *nextPick;
@property (strong, nonatomic) Pick *currentPick;
@property (strong, nonatomic) Quote *quote;
@property (strong, nonatomic) NSTimer *quoteTimer;

- (void)fetchQuote;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameLabel setText:nil];
    [self.valueLabel setText:nil];
    [self.picksLabel setText:nil];
    [self.winnersLabel setText:nil];
    [self.losersLabel setText:nil];
    [self.nextPickButton setHidden:YES];
    self.picks = [[NSMutableArray alloc] init];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ParseClient instance] fetchAccountForUser:PFUser.currentUser callback:^(NSObject *object, NSError *error) {
        if (!error) {
            self.account = (Account *)object;
            [self fetchPicks];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.quoteTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchQuote) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.quoteTimer invalidate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Today's Pick";
    }
    return @"Previous Picks";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.picks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell clearSubviews];
    
    if (indexPath.section == 0) {
        if (self.currentPick) {
            [cell.dateLabel setText:[[DateHelper instance] dayFormatForDate:self.currentPick.tradeDate]];
            [cell.symbolLabel setText:self.currentPick.symbol];
            if (self.quote.open != 0) {
                float priceChange = self.quote.price - self.quote.open;
                float percentChange = priceChange / self.quote.open * 100;
                float estimatedValue = self.account.value + (self.account.value * percentChange / 100);
                [cell.buyLabel setText:[NSString stringWithFormat:@"%0.02f-O", self.quote.open]];
                [cell.valueLabel setText:[NSString stringWithFormat:@"%@ (Est)", [PriceFormatter formatForValue:estimatedValue]]];
                [cell.changeLabel setText:[PriceFormatter formatForPriceChange:priceChange andPercentChange:percentChange]];
                [cell.changeLabel setTextColor:[PriceFormatter colorForChange:priceChange]];
            }
        }
        else if (![[DateHelper instance] isMarketOpenOnDate:[NSDate date]]) {
            [cell.buyLabel setText:@"Market Closed"];
        }
    }
    else {
        Pick *pick = [self.picks objectAtIndex:indexPath.row];
        [cell.dateLabel setText:[[DateHelper instance] dayFormatForDate:pick.tradeDate]];
        [cell.symbolLabel setText:pick.symbol];
        [cell.buyLabel setText:[NSString stringWithFormat:@"%0.02f-O", pick.open]];
        [cell.sellLabel setText:[NSString stringWithFormat:@"%0.02f-C", pick.close]];
        [cell.valueLabel setText:[PriceFormatter formatForValue:pick.value + pick.change]];
        [cell.changeLabel setText:[PriceFormatter formatForPick:pick]];
        [cell.changeLabel setTextColor:[PriceFormatter colorForChange:pick.change]];
    }
    
    return cell;
}

- (IBAction)onLogOutButtonTouched:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
}

- (void)updateNextPick:(Pick *)pick {
    self.nextPick = pick;
    [self refreshViews];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowPickSegue"]) {
        if (self.nextPick) {
            [self.nextPick deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.nextPick = nil;
                    [self refreshViews];
                }
            }];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPickSegue"]) {
        PickViewController *pickViewController = segue.destinationViewController;
        [pickViewController setDelegate:self];
        pickViewController.account = self.account;
    }
}

- (void)refreshViews {
    [self.nameLabel setText:self.account.user.username];
    [self.valueLabel setText:[PriceFormatter formatForValue:self.account.value]];
    
    int picks = self.account.winners + self.account.losers;
    if (picks == 0) {
        [self.picksLabel setText:@"No Picks"];
        [self.winnersLabel setText:nil];
        [self.losersLabel setText:nil];
    }
    else {
        [self.picksLabel setText:[NSString stringWithFormat:@"%d Picks", self.account.winners + self.account.losers]];
        [self.winnersLabel setText:[NSString stringWithFormat:@"+%d", self.account.winners]];
        [self.winnersLabel setTextColor:[UIColor greenColor]];
        [self.losersLabel setText:[NSString stringWithFormat:@"-%d", self.account.losers]];
        [self.losersLabel setTextColor:[UIColor redColor]];
    }
    if (self.nextPick) {
        [self.nextPickLabel setText:[NSString stringWithFormat:@"Next Pick: %@", self.nextPick.symbol]];
        [self.nextPickButton setTitle:@"Remove" forState:UIControlStateNormal];
    }
    else {
        [self.nextPickLabel setText: nil];
        [self.nextPickButton setTitle:@"Set Pick" forState:UIControlStateNormal];
    }
    [self.nextPickButton setHidden:NO];
    
    [self.tableView reloadData];
}

- (void)fetchQuote {
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

- (void)fetchPicks {
    [[ParseClient instance] fetchPicksForAccount:self.account withSkip:0 callback:^(NSArray *objects, NSError *error) {
        [self.picks removeAllObjects];
        if (!error) {
            [self sortPicksFromObjects:objects];
            [self fetchQuote];
            [self refreshViews];
            [self enableInfiniteScroll];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)sortPicksFromObjects:(NSArray *)objects {
    NSDate *lastTradeDate = [[DateHelper instance] lastTradeDate];
    NSDate *nextTradeDate = [[DateHelper instance] nextTradeDate];
    for (Pick* pick in objects) {
        NSDate *tradeDate = pick.tradeDate;
        if (!pick.processed && [lastTradeDate compare:tradeDate] == NSOrderedSame) {
            self.currentPick = pick;
        }
        else if ([nextTradeDate compare:tradeDate] == NSOrderedSame) {
            self.nextPick = pick;
        }
        else {
            [self.picks addObject:pick];
        }
    }
}

- (void)enableInfiniteScroll {
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        long skip = (self.nextPick ? 1 : 0) + (self.currentPick ? 1 : 0) + self.picks.count;
        [[ParseClient instance] fetchPicksForAccount:self.account withSkip:skip callback:^(NSArray *objects, NSError *error) {
            if (!error) {
                [self.picks addObjectsFromArray:objects];
                [self.tableView reloadData];
                [self.tableView.infiniteScrollingView stopAnimating];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
}

@end
