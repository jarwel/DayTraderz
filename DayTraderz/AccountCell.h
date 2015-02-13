//
//  AccountCell.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPicksLabel;
@property (weak, nonatomic) IBOutlet UILabel *badPicksLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
