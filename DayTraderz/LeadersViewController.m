//
//  LeadersViewController.m
//  DayTraderz
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

@interface LeadersViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *accounts;

@end

@implementation LeadersViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];

    self.accounts = [[NSMutableArray alloc] init];
    [[ParseClient instance] fetchLeadersSortedByColumn:[self columnSelected] withSkip:self.accounts.count callback:^(NSArray *objects, NSError *error) {
        [self.accounts addObjectsFromArray:objects];
        [self.tableView reloadData];
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [[ParseClient instance] fetchLeadersSortedByColumn:[self columnSelected] withSkip:self.accounts.count callback:^(NSArray *objects, NSError *error) {
                [self.accounts addObjectsFromArray:objects];
                [self.tableView reloadData];
                [self.tableView.infiniteScrollingView stopAnimating];
            }];
        }];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = [self.accounts objectAtIndex:indexPath.row];
    
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = account.user.username;
    cell.picksLabel.text = [NSString stringWithFormat:@"%d Picks:", account.winners + account.losers];
    cell.winnersLabel.text = [NSString stringWithFormat:@"+%d", account.winners];
    cell.winnersLabel.textColor = [UIColor greenColor];
    cell.losersLabel.text = [NSString stringWithFormat:@"-%d", account.losers];
    cell.losersLabel.textColor = [UIColor redColor];
    cell.valueLabel.text = [PriceFormatter valueFormat:account.value];
    return cell;
}

- (IBAction)onValueChanged:(id)sender {
    [self.accounts removeAllObjects];
    [[ParseClient instance] fetchLeadersSortedByColumn:[self columnSelected] withSkip:self.accounts.count callback:^(NSArray *objects, NSError *error) {
        [self.accounts addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

- (NSString *)columnSelected {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1: return @"winners";
        case 2: return @"losers";
        default: return @"value";
    }
}

@end
