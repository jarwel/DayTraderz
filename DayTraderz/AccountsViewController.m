//
//  AccountsViewController.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AccountsViewController.h"
#import "Account.h"
#import "AccountCell.h"
#import "ParseClient.h"
#import "PriceFormatter.h"

@interface AccountsViewController ()

@property(strong, nonatomic) NSArray *accounts;

@end

@implementation AccountsViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    
    [[ParseClient instance] fetchAccountLeaders:^(NSArray *objects, NSError *error) {
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
    cell.goodPicksLabel.text = [NSString stringWithFormat:@"+%d Good", account.goodPicks];
    cell.goodPicksLabel.textColor = [UIColor greenColor];
    cell.badPicksLabel.text = [NSString stringWithFormat:@"-%d Bad", account.badPicks];
    cell.badPicksLabel.textColor = [UIColor redColor];
    cell.valueLabel.text = [PriceFormatter valueFormat:account.value];
    return cell;
}

@end
