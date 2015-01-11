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

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Account";
}

+ (Account *)initWithUser:(PFUser *)user {
    Account *account = [Account object];
    account.value = 1000.00f;
    account.user = user;
    return account;
}

@end
