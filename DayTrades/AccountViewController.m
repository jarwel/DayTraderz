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
@property (assign, nonatomic) float lastPrice;

- (void)applicationBecameActive;
- (void)applicationBecameInactive;
- (void)fetchQuote;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-1.jpg"]]];
    
    [self.nameLabel setText:nil];
    [self.valueLabel setText:nil];
    [self.picksLabel setText:nil];
    [self.winnersLabel setText:nil];
    [self.losersLabel setText:nil];
    [self.nextPickLabel setText:nil];
    [self.nextPickButton setHidden:YES];
    self.picks = [[NSMutableArray alloc] init];
    
    UINib *pickCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:pickCell forCellReuseIdentifier:cellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameInactive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self applicationBecameActive];
}

- (void)applicationBecameActive {
    NSLog(@"application became active");
    
    [[ParseClient instance] fetchAccountForUser:PFUser.currentUser callback:^(NSObject *object, NSError *error) {
        if (!error) {
            self.account = (Account *)object;
            [self fetchPicks];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self.quoteTimer invalidate];
    self.quoteTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchQuote) userInfo:nil repeats:YES];
}

- (void)applicationBecameInactive {
    NSLog(@"application became inactive");
    
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
    [cell clearFields];
    
    if (indexPath.section == 0) {
        if (self.currentPick) {
            [cell.dateLabel setText:[[DateHelper instance] dayFormatForDate:self.currentPick.tradeDate]];
            [cell.symbolLabel setText:self.currentPick.symbol];
            if (self.quote.open != 0) {
                float priceChange = self.quote.price - self.quote.open;
                float percentChange = priceChange / self.quote.open * 100;
                float estimatedValue = self.account.value + (self.account.value * percentChange / 100);
                [cell.buyLabel setText:[NSString stringWithFormat:@"%0.02f", self.quote.open]];
                [cell.sellLabel setText:[NSString stringWithFormat:@"%0.02f", self.quote.price]];
                [cell.openLabel setText:@"-O"];
                [cell.valueLabel setText:[NSString stringWithFormat:@"%@ (Est)", [PriceFormatter formatForValue:estimatedValue]]];
                [cell.changeLabel setText:[PriceFormatter formatForPriceChange:priceChange andPercentChange:percentChange]];
                [cell.changeLabel setTextColor:[PriceFormatter colorForChange:priceChange]];
                
                if (self.quote.price != 0 && self.quote.price != self.lastPrice) {
                    UIColor *color = [PriceFormatter colorForChange:self.quote.price - self.lastPrice];
                    [self flashTextColor:color forLabel:cell.sellLabel];
                    [self flashTextColor:color forLabel:cell.valueLabel];
                }
                self.lastPrice = self.quote.price;
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
        [cell.buyLabel setText:[NSString stringWithFormat:@"%0.02f", pick.open]];
        [cell.sellLabel setText:[NSString stringWithFormat:@"%0.02f", pick.close]];
        [cell.openLabel setText:@"-O"];
        [cell.closeLabel setText:@"-C"];
        [cell.valueLabel setText:[PriceFormatter formatForValue:pick.value + pick.change]];
        [cell.changeLabel setText:[PriceFormatter formatForPick:pick]];
        [cell.changeLabel setTextColor:[PriceFormatter colorForChange:pick.change]];
        [cell.sellLabel setTextColor:[UIColor whiteColor]];
        [cell.valueLabel setTextColor:[UIColor whiteColor]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* headerFooterView = (UITableViewHeaderFooterView*) view;
        [headerFooterView.contentView setBackgroundColor:[UIColor darkGrayColor]];
        [headerFooterView.textLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float y = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    if (self.tableView.contentOffset.y >= y) {
        [self.tableView setContentOffset:CGPointMake(0, y)];
    }
}

- (IBAction)onLogOutButtonTouched:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
}

- (void)updateNextPick:(Pick *)pick {
    self.nextPick = pick;
    [self refreshViews];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowPickSegue"]) {
        NSDate *nextTradeDate = [[DateHelper instance] nextTradeDate];
        if (self.nextPick && [nextTradeDate compare:self.nextPick.tradeDate] == NSOrderedSame) {
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
    
    int count = self.account.winners + self.account.losers;
    if (count == 0) {
        [self.picksLabel setText:@"No Picks"];
        [self.winnersLabel setText:nil];
        [self.losersLabel setText:nil];
    }
    else {
        [self.picksLabel setText:[NSString stringWithFormat:@"%d Pick%@", count, count > 1 ? @"s" : @""]];
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
        [self.nextPickButton setTitle:@"Set Next" forState:UIControlStateNormal];
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
                    [self.tableView reloadData];
                }
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)fetchPicks {
    [[ParseClient instance] fetchPicksForAccount:self.account withLimit:10 withSkip:0 callback:^(NSArray *objects, NSError *error) {
        self.nextPick = nil;
        self.currentPick = nil;
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
    for (Pick *pick in objects) {
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

- (void)flashTextColor:(UIColor *)color forLabel:(UILabel *)label {
    [UIView transitionWithView: label duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        label.textColor = color;
    } completion:^(BOOL finished) {
        label.textColor = [UIColor whiteColor];
    }];
}

- (void)enableInfiniteScroll {
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        long skip = (self.nextPick ? 1 : 0) + (self.currentPick ? 1 : 0) + self.picks.count;
        [[ParseClient instance] fetchPicksForAccount:self.account withLimit:5 withSkip:skip callback:^(NSArray *objects, NSError *error) {
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
