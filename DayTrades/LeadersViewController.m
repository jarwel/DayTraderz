//
//  LeadersViewController.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "LeadersViewController.h"
#import "DayTrades-Swift.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ParseClient.h"

@interface LeadersViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *accounts;
@property (strong, nonatomic) NSMutableSet *animated;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation LeadersViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accounts = [[NSMutableArray alloc] init];
    self.animated = [[NSMutableSet alloc] init];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-3.jpg"]]];
    [self.segmentedControl setBackgroundColor:[UIColor translucentColor]];
    
    UINib *accountCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:accountCell forCellReuseIdentifier:cellIdentifier];
    [self.tableView setAllowsSelection:NO];
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
    [cell resetView];
    
    if (indexPath.section == 0) {
        Account *account = [self.accounts objectAtIndex:indexPath.row];
        if (![account.user.username isEqualToString:cell.nameLabel.text]) {
            [cell.nameLabel setText:account.user.username];
            [cell.valueLabel setText:[self.numberFormatter USDFromDouble:account.value]];
            cell.picksBarView.value = account.winners;
            cell.picksBarView.total = account.winners + account.losers;
            if ([self.animated containsObject:account.user.username]) {
                [cell.picksBarView animate:0];
            }
            else {
                [self.animated addObject:account.user.username];
                [cell.picksBarView animate:1];
            }
        }
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
    [self.animated removeAllObjects];
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
        [[ParseClient instance] fetchAccountsSortedByColumn:column withLimit:10 withSkip:skip callback:^(NSArray *objects, NSError *error) {
            if ([column isEqualToString:[self columnSelected]]) {
                if (!error && objects.count > 0) {
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
