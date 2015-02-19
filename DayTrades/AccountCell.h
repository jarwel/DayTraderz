//
//  AccountCell.h
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *picksLabel;
@property (weak, nonatomic) IBOutlet UILabel *winnersLabel;
@property (weak, nonatomic) IBOutlet UILabel *losersLabel;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
