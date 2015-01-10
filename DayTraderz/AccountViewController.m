//
//  AccountViewController.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AccountViewController.h"
#import "PickCell.h"

@interface AccountViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AccountViewController

static NSString * const cellIdentifier = @"PickCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *userCell = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [self.tableView registerNib:userCell forCellReuseIdentifier:cellIdentifier];
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
    return cell;
}

@end
