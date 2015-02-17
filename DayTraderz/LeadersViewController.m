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
#import "DateHelper.h"

@interface LeadersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *currentSortColumn;
@property (strong, nonatomic) NSMutableArray *accounts;

@end

@implementation LeadersViewController

static NSString * const cellIdentifier = @"AccountCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];

    self.accounts = [[NSMutableArray alloc] init];
    [self sortLeadersByColumn:@"value"];
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

- (void)sortLeadersByColumn:(NSString *)column {
    if (![column isEqualToString:self.currentSortColumn]) {
        [self.accounts removeAllObjects];
        self.currentSortColumn = column;
    }
    [[ParseClient instance] fetchLeadersSortedByColumn:column withSkip:self.accounts.count callback:^(NSArray *objects, NSError *error) {
        [self.accounts addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

- (IBAction)onValueChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
        case 1: [self sortLeadersByColumn:@"winners"];
            break;
        case 2: [self sortLeadersByColumn:@"losers"];
            break;
        default: [self sortLeadersByColumn:@"value"];
    }
}

@end
