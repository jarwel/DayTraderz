//
//  ParseClient.m
//  DayTrades
//
//  Created by Jason Wells on 2/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "ParseClient.h"

@implementation ParseClient

+ (ParseClient *)instance {
    static ParseClient *instance;
    if (!instance) {
        instance = [[ParseClient alloc] init];
    }
    return instance;
}

- (void)fetchAccountForUser:(PFUser *)user callback:(void(^)(NSObject *object, NSError *error))callback {
    PFQuery *query = [Account query];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:callback];
}

- (void)fetchPicksForAccount:(Account *)account withLimit:(int)limit withSkip:(int)skip callback:(void(^)(NSArray *objects, NSError *error))callback {
    PFQuery *query = [Pick query];
    [query includeKey:@"account"];
    [query whereKey:@"account" equalTo:account];
    [query orderByDescending:@"tradeDate"];
    [query setLimit:limit];
    [query setSkip:skip];
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)fetchAccountsSortedByColumn:(NSString *)column withLimit:(int)limit withSkip:(int)skip callback:(void(^)(NSArray *objects, NSError *error))callback {
    PFQuery *query = [Account query];
    [query includeKey:@"user"];
    [query orderByDescending:column];
    [query setLimit:limit];
    [query setSkip:skip];
    [query findObjectsInBackgroundWithBlock:callback];
}

- (void)createOrUpdatePick:(Pick *)pick {
    PFQuery *query = [Pick query];
    [query whereKey:@"account" equalTo:pick.account];
    [query whereKey:@"tradeDate" equalTo:pick.tradeDate];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [pick saveInBackground];
            }];
        }
        else {
            [pick saveInBackground];
        }
    }];
}

@end
