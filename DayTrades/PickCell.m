//
//  PickCell.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PickCell.h"

@implementation PickCell

- (void)awakeFromNib {
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    [self clearFields];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clearFields {
    [self.symbolLabel setText:nil];
    [self.dateLabel setText:nil];
    [self.buyLabel setText:nil];
    [self.sellLabel setText:nil];
    [self.openLabel setText:nil];
    [self.closeLabel setText:nil];
    [self.changeLabel setText:nil];
    [self.valueLabel setText:nil];
}

@end
