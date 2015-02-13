//
//  LeadersViewController.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "LeadersViewController.h"
#import "Account.h"
#import "AccountCell.h"
#import "ParseClient.h"
#import "PriceFormatter.h"

@interface LeadersViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property(strong, nonatomic) NSArray *accounts;

@end

@implementation LeadersViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    
    [[ParseClient instance] fetchLeadersSortedByColumn:@"value" callback:^(NSArray *objects, NSError *error) {
        self.accounts = objects;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = [self.accounts objectAtIndex:indexPath.row];
    
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.nameLabel.text = account.user.username;
    cell.totalPicksLabel.text = [NSString stringWithFormat:@"%d Picks:", account.goodPicks + account.badPicks];
    cell.goodPicksLabel.text = [NSString stringWithFormat:@"+%d", account.goodPicks];
    cell.goodPicksLabel.textColor = [UIColor greenColor];
    cell.badPicksLabel.text = [NSString stringWithFormat:@"-%d", account.badPicks];
    cell.badPicksLabel.textColor = [UIColor redColor];
    cell.valueLabel.text = [PriceFormatter valueFormat:account.value];
    return cell;
}

@end
