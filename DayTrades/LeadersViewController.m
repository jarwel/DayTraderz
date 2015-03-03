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
#import "UIColor+Application.h"

@interface LeadersViewController ()

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-3.jpg"]]];
    [self.segmentedControl setBackgroundColor:[UIColor translucentColor]];
    
    self.accounts = [[NSMutableArray alloc] init];
    
    UINib *accountCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:accountCell forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAccounts];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.accounts.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell clearFields];
    
    if (indexPath.section == 0) {
        Account *account = [self.accounts objectAtIndex:indexPath.row];
        [cell.nameLabel setText:account.user.username];
        [cell.winnersLabel setText:[NSString stringWithFormat:@"+%d", account.winners]];
        [cell.winnersLabel setTextColor:[UIColor greenColor]];
        [cell.losersLabel setText:[NSString stringWithFormat:@"-%d", account.losers]];
        [cell.losersLabel setTextColor:[UIColor redColor]];
        [cell.valueLabel setText:[PriceFormatter formatForValue:account.value]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int headerHeight = 22;
    int cellHeight = 44;
    if(indexPath.section == 1) {
        return MAX(self.tableView.frame.size.height - headerHeight - (self.accounts.count * cellHeight), 0);
    }
    return cellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Top Traders";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass: [UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* headerFooterView = (UITableViewHeaderFooterView*) view;
        [headerFooterView.contentView setBackgroundColor:[UIColor darkGrayColor]];
        [headerFooterView.textLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor translucentColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float y = self.tableView.contentSize.height - self.tableView.bounds.size.height + self.tableView.infiniteScrollingView.frame.size.height + 1;
    if (self.tableView.contentOffset.y >= y) {
        [self.tableView setContentOffset:CGPointMake(0, y)];
    }
}

- (IBAction)onValueChanged:(id)sender {
    [self fetchAccounts];
}

- (NSString *)columnSelected {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return @"value";
    }
    return @"winners";
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
    [self.tableView.infiniteScrollingView setBackgroundColor:[UIColor translucentColor]];
}

@end
