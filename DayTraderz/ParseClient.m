//
//  ParseClient.m
//  DayTraderz
//
//  Created by Jason Wells on 2/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "ParseClient.h"

@implementation ParseClient

+ (ParseClient *)instance {
    static ParseClient *instance;
    if (! instance) {
        instance = [[ParseClient alloc] init];
    }
    return instance;
}

- (void)fetchAccountLeaders:(void(^)(NSArray *objects, NSError *error))callback {
    PFQuery *query = [Account query];
    [query includeKey:@"user"];
    [query orderByDescending:@"value"];
    [query setLimit:10];
    [query findObjectsInBackgroundWithBlock:callback];
    
}

- (void)fetchAccountForUser:(PFUser *)user callback:(void(^)(NSArray *objects, NSError *error))callback {
    PFQuery *query = [Account query];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)fetchPicksForUser:(PFUser *)user callback:(void(^)(NSArray *objects, NSError *error))callback {
    PFQuery *query = [Pick query];
    [query includeKey:@"account"];
    [query whereKey:@"user" equalTo:user];
    [query orderByDescending:@"tradeDate"];
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)fetchPicksForAccount:(Account *)account callback:(void(^)(NSArray *objects, NSError *error))callback {
    PFQuery *query = [Pick query];
    [query includeKey:@"account"];
    [query whereKey:@"account" equalTo:account];
    [query orderByDescending:@"tradeDate"];
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)createAccountForUser:(PFUser *)user callback:(void(^)(BOOL succeeded, NSError *error))callback {
    Account *account = [[Account alloc] init];
    account.user = user;
    account.value = 10000;
    [account saveInBackgroundWithBlock:callback];
}

@end
