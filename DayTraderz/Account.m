//
//  Account.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "Account.h"

@implementation Account

@dynamic user;
@dynamic value;
@dynamic goodPicks;
@dynamic badPicks;

+ (NSString *)parseClassName {
    return @"Account";
}

- (id)initForUser:(PFUser *)user {
    if (self = [super init]) {
        self.user = user;
        self.value = 10000;
        self.goodPicks = 0;
        self.badPicks = 0;
    }
    return self;
}

@end
