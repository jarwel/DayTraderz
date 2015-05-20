//
//  Pick.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "Pick.h"

@implementation Pick

@dynamic user;
@dynamic account;
@dynamic dayOfTrade;
@dynamic symbol;
@dynamic open;
@dynamic close;
@dynamic value;
@dynamic change;
@dynamic processed;

+ (NSString *)parseClassName {
    return @"Pick";
}

- (id)initForAccount:(Account *)account withSymbol:(NSString *)symbol withDayOfTrade:(NSString *)dayOfTrade {
    if (self = [super init]) {
        self.account = account;
        self.user = account.user;
        self.symbol = symbol;
        self.dayOfTrade = dayOfTrade;
    }
    return self;
}

@end
