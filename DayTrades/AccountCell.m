//
//  AccountCell.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AccountCell.h"

@implementation AccountCell

- (void)awakeFromNib {
    [self clearFields];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clearFields {
    [self.nameLabel setText:nil];
    [self.winnersLabel setText:nil];
    [self.losersLabel setText:nil];
    [self.valueLabel setText:nil];
}

@end
