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
#import "DayQuote.h"
#import "PickCell.h"

@interface AccountViewController () <PicksViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) Pick *nextPick;
@property (strong, nonatomic) Pick *currentPick;
@property (strong, nonatomic) NSMutableArray *picks;
@property (strong, nonatomic) NSMutableDictionary *quotes;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picks = [[NSMutableArray alloc] init];
    self.quotes = [[NSMutableDictionary alloc ] init];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    
    [[ParseClient instance] fetchAccountForUser:PFUser.currentUser callback:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.account = objects[0];
        }
    }];
    
    [[ParseClient instance] fetchPicksForUser:PFUser.currentUser callback:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self updateViewsWithObjects:objects];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Tomorrow";
    }
    
    if (section == 1) {
        return @"Today";
    }
    return @"Historical";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 2) {
        return 1;
    }
    return self.picks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0 && self.nextPick) {
        cell.dateLabel.text = [self formatTradeDate:self.nextPick.tradeDate];
        cell.symbolLabel.text = self.nextPick.symbol;
    }
    
    if (indexPath.section == 1 && self.currentPick) {
        cell.dateLabel.text = [self formatTradeDate:self.currentPick.tradeDate];
        cell.symbolLabel.text = self.currentPick.symbol;
    }
    
    if (indexPath.section == 2) {
        Pick* pick = [self.picks objectAtIndex:indexPath.row];
        cell.dateLabel.text = [self formatTradeDate:pick.tradeDate];
        cell.symbolLabel.text = pick.symbol;
        
        NSString *key = [NSString stringWithFormat:@"%@-%@", pick.symbol, pick.tradeDate];
        Quote *quote = [self.quotes objectForKey:key];
        
        
    }
    
    return cell;
}

- (void)pickFromController:(Pick *)pick {
    self.nextPick = pick;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPicksSegue"]) {
        PicksViewController *picksViewController = segue.destinationViewController;
        picksViewController.delegate = self;
        picksViewController.account = self.account;
    }
}

- (BOOL)isCurrentPick:(Pick *) pick {
    if (pick) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* today = [formatter stringFromDate:[NSDate date]];
        if ([today isEqualToString:pick.tradeDate]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isNextPick:(Pick *) pick {
    if (pick) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate* date = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:[NSDate date] options:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString* today = [formatter stringFromDate:date];
        if ([today isEqualToString:pick.tradeDate]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)formatTradeDate:(NSString *)tradeDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatter dateFromString:tradeDate];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    return [formatter stringFromDate:date];
}

- (void)updateViewsWithObjects:(NSArray *)objects {
    [self.picks removeAllObjects];
    
    float value = 0;
    for (Pick* pick in objects) {
        if ([self isNextPick:pick]) {
            self.nextPick = pick;
        }
        else if ([self isCurrentPick:pick]) {
            self.currentPick = pick;
        }
        else {
            [self.picks addObject:pick];
            [[FinanceClient instance] fetchQuoteForSymbol:pick.symbol onDate:pick.tradeDate callback:^(NSURLResponse *response, NSData *data, NSError *error) {
                if (!error) {
                    DayQuote* dayQuote = [DayQuote fromData:data];
                    if (dayQuote) {
                        NSString *key = [NSString stringWithFormat:@"%@-%@", dayQuote.symbol, dayQuote.date];
                        [self.quotes setObject:dayQuote forKey:key];
                    }
                }
            }];
        }
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"$%0.02f", value];
    [self.tableView reloadData];
}

- (IBAction)onLogOutButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
}


@end
