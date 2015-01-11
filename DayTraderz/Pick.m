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
@dynamic date;
@dynamic symbol;
@dynamic priceBought;
@dynamic priceSold;
@dynamic accountValue;

+ (NSString *)parseClassName {
    return @"Pick";
}

+ (Pick *)initForAccount:(Account *)account withSymbol:(NSString *)symbol {
    Pick *pick = [Pick object];
    pick.user = account.user;
    pick.account = account;
    pick.symbol = symbol;
    return pick;
}

@end
