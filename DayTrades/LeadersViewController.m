//
//  LeadersViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "LeadersViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Account.h"
#import "AccountCell.h"
#import "ParseClient.h"
#import "PriceFormatter.h"
#import "DateHelper.h"
#import "UIColor+TableView.h"

@interface LeadersViewController ()

@property (weak, nonatomic) IBOutlet UILabel *processedDate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *accounts;

@end

@implementation LeadersViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.segmentedControl setBackgroundColor:[UIColor tableViewBackgroundColor]];
    [self.segmentedControl setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-3.jpg"]]];
    
    [self.processedDate setText:nil];
    self.accounts = [[NSMutableArray alloc] init];
    
    UINib *accountCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:accountCell forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAccounts];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Top Traders";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = [self.accounts objectAtIndex:indexPath.row];
    
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.nameLabel setText:account.user.username];
    [cell.winnersLabel setText:[NSString stringWithFormat:@"+%d", account.winners]];
    [cell.winnersLabel setTextColor:[UIColor greenColor]];
    [cell.losersLabel setText:[NSString stringWithFormat:@"-%d", account.losers]];
    [cell.losersLabel setTextColor:[UIColor redColor]];
    [cell.valueLabel setText:[PriceFormatter formatForValue:account.value]];
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
    [cell setBackgroundColor:[UIColor tableViewBackgroundColor]];
}

- (IBAction)onValueChanged:(id)sender {
    [self fetchAccounts];
}

- (NSString *)columnSelected {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: return @"winners";
        case 2: return @"losers";
        default: return @"value";
    }
}

- (void)fetchAccounts {
    NSString *column = [self columnSelected];
    [[ParseClient instance] fetchAccountsSortedByColumn:column withLimit:15 withSkip:0 callback:^(NSArray *objects, NSError *error) {
        if ([column isEqualToString:[self columnSelected]]) {
            [self.accounts removeAllObjects];
            if (!error) {
                [self.accounts addObjectsFromArray:objects];
                [self.tableView reloadData];
                [self enableInfiniteScroll];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }
    }];
}

- (void)enableInfiniteScroll {
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSString *column = [self columnSelected];
        long skip = self.accounts.count;
        [[ParseClient instance] fetchAccountsSortedByColumn:column withLimit:5 withSkip:skip callback:^(NSArray *objects, NSError *error) {
            if ([column isEqualToString:[self columnSelected]]) {
                if (!error) {
                    [self.accounts addObjectsFromArray:objects];
                    [self.tableView reloadData];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }];
    [self.tableView.infiniteScrollingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.tableView.infiniteScrollingView setBackgroundColor:[UIColor tableViewBackgroundColor]];
}

@end
