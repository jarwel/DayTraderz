//
//  PickCell.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PickCell.h"

@implementation PickCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)clearSubviews {
    self.symbolLabel.text = @"";
    self.dateLabel.text = @"";
    self.buyLabel.text = @"";
    self.sellLabel.text = @"";
    self.changeLabel.text = @"";
    self.valueLabel.text = @"";
}

@end
