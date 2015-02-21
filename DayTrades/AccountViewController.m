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

@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) Pick *nextPick;
@property (strong, nonatomic) Pick *currentPick;
@property (strong, nonatomic) NSMutableArray *picks;
@property (strong, nonatomic) Quote *quote;
@property (strong, nonatomic) NSTimer *quoteTimer;

- (void)fetchQuote;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = nil;
    self.valueLabel.text = nil;
    self.picksLabel.text = nil;
    self.winnersLabel.text = nil;
    self.losersLabel.text = nil;
    self.nextPickButton.hidden = YES;
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    self.picks = [[NSMutableArray alloc] init];
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
    [cell clearSubviews];
    
    if (indexPath.section == 0 && !self.currentPick.processed) {
        cell.dateLabel.text = [[DateHelper instance] tradeDateFormat:self.currentPick.tradeDate];
        cell.symbolLabel.text = self.currentPick.symbol;
        if (self.quote.open != 0) {
            float estimatedValue = self.account.value + (self.account.value * self.quote.percentChange / 100);
            cell.buyLabel.text = [NSString stringWithFormat:@"%0.02f-O", self.quote.open];
            cell.valueLabel.text = [NSString stringWithFormat:@"%@ (Est)", [PriceFormatter valueFormat:estimatedValue]];
            cell.changeLabel.text = [PriceFormatter changeFormatFromQuote:self.quote];
            cell.changeLabel.textColor = [PriceFormatter colorFromChange:self.quote.priceChange];
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
        cell.dateLabel.text = [[DateHelper instance] tradeDateFormat:pick.tradeDate];
        cell.symbolLabel.text = pick.symbol;
        cell.buyLabel.text = [NSString stringWithFormat:@"%0.02f-O", pick.open];
        cell.sellLabel.text = [NSString stringWithFormat:@"%0.02f-C", pick.close];
        cell.valueLabel.text = [PriceFormatter valueFormat:pick.value + pick.change];
        cell.changeLabel.text = [PriceFormatter changeFormatFromPick:pick];
        cell.changeLabel.textColor = [PriceFormatter colorFromChange:pick.change];
    }
    
    return cell;
}

- (IBAction)onLogOutButtonTouched:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
}

- (IBAction)onNextPickButtonTouched:(id)sender {
    if (self.nextPick) {
        [self.nextPick deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                self.nextPick = nil;
                [self refreshViews];
            }
        }];
    }
    else {
        [self performSegueWithIdentifier: @"ShowPickSegue" sender: self];
    }
}

- (void)updateNextPick:(Pick *)pick {
    self.nextPick = pick;
    [self refreshViews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPickSegue"]) {
        PickViewController *pickViewController = segue.destinationViewController;
        pickViewController.delegate = self;
        pickViewController.account = self.account;
    }
}

- (void)refreshViews {
    self.nameLabel.text = self.account.user.username;
    self.valueLabel.text = [PriceFormatter valueFormat:self.account.value];
    
    int picks = self.account.winners + self.account.losers;
    if (picks == 0) {
        self.picksLabel.text = @"No Picks";
        self.winnersLabel.text = nil;
        self.losersLabel.text = nil;
    }
    else {
        self.picksLabel.text = [NSString stringWithFormat:@"%d Picks", self.account.winners + self.account.losers];
        self.winnersLabel.text = [NSString stringWithFormat:@"+%d", self.account.winners];
        self.winnersLabel.textColor = [UIColor greenColor];
        self.losersLabel.text = [NSString stringWithFormat:@"-%d", self.account.losers];
        self.losersLabel.textColor = [UIColor redColor];
    }
    if (self.nextPick) {
        self.nextPickLabel.text = [NSString stringWithFormat:@"Next Pick: %@", self.nextPick.symbol];
        [self.nextPickButton setTitle:@"Remove" forState:UIControlStateNormal];
    }
    else {
        self.nextPickLabel.text = nil;
        [self.nextPickButton setTitle:@"Next Pick" forState:UIControlStateNormal];
    }
    self.nextPickButton.hidden = NO;
    
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
            [self parsePicksFromObjects:objects];
            [self fetchQuote];
            [self refreshViews];
            [self enableInfiniteScroll];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)parsePicksFromObjects:(NSArray *)objects {
    for (Pick* pick in objects) {
        if ([self isNextPick:pick]) {
            self.nextPick = pick;
        }
        else if ([self isCurrentPick:pick]) {
            self.currentPick = pick;
        }
        else {
            [self.picks addObject:pick];
        }
    }
}

- (BOOL)isCurrentPick:(Pick *) pick {
    if (pick) {
        NSDate *tradeDate = pick.tradeDate;
        NSDate *lastTradeDate = [[DateHelper instance] lastTradeDate];
        if ([lastTradeDate compare:tradeDate] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isNextPick:(Pick *) pick {
    if (pick) {
        NSDate *tradeDate = pick.tradeDate;
        NSDate *nextTradeDate = [[DateHelper instance] nextTradeDate];
        if ([nextTradeDate compare:tradeDate] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
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