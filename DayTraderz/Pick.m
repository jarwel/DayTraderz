//
//  Pick.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "Pick.h"

@implementation Pick

@dynamic user;
@dynamic account;
@dynamic tradeDate;
@dynamic symbol;
@dynamic open;
@dynamic close;
@dynamic value;
@dynamic shares;
@dynamic change;

+ (NSString *)parseClassName {
    return @"Pick";
}

+ (Pick *)initForAccount:(Account *)account withSymbol:(NSString *)symbol withDate:(NSDate *)date {
    Pick *pick = [Pick object];
    pick.user = account.user;
    pick.account = account;
    pick.symbol = symbol;
    pick.tradeDate = date;
    return pick;
}

@end
