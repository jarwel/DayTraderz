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

@interface AccountsViewController ()

@property(strong, nonatomic) NSArray *accounts;

@end

@implementation AccountsViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    
    NSMutableArray *accounts = [[NSMutableArray alloc] init];
    
    Account *account1 = [[Account alloc] init];
    account1.value = 10000.00f;
    [accounts addObject:account1];
    
    Account *account2 = [[Account alloc] init];
    account2.value = 10000.00f;
    [accounts addObject:account2];
    
    _accounts = accounts;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _accounts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Account *account = [self.accounts objectAtIndex:indexPath.row];
    
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.accountName.text = @"User Name";
    cell.accountValue.text = [NSString stringWithFormat:@"%0.2f", account.value];
    return cell;
}

@end
