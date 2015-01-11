//
//  AccountViewController.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AccountViewController.h"
#import "AppConstants.h"
#import "PicksViewController.h"
#import "Account.h"
#import "PickCell.h"

@interface AccountViewController () <PicksViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Pick *todaysPick;
@property (strong, nonatomic) Pick *tomorrowsPick;
@property (strong, nonatomic) NSArray *historicalPick;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
    
    PFQuery *query = [Account query];
    [query whereKey:@"user" equalTo:PFUser.currentUser];
    
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (_tomorrowsPick) {
            cell.dateLabel.text = [self formatDate:_tomorrowsPick.date];
            cell.symbolLabel.text = _tomorrowsPick.symbol;
        }
    }
    
    return cell;
}

- (void)pickFromController:(Pick *)pick {
    _tomorrowsPick = pick;
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPicksSegue"]) {
        PicksViewController *picksViewController = segue.destinationViewController;
        picksViewController.delegate = self;
    }
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    return [formatter stringFromDate:date];
}

- (IBAction)onLogOutButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogOutNotification object:nil];
}


@end
