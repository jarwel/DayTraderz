//
//  ParseClient.h
//  DayTraderz
//
//  Created by Jason Wells on 2/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Account.h"
#import "Pick.h"

@interface ParseClient : NSObject

+ (ParseClient *)instance;
- (void)fetchAccountForUser:(PFUser *)user callback:(void(^)(NSArray *objects, NSError *error))callback;
- (void)fetchPicksForAccount:(Account *)account withSkip:(long)skip callback:(void(^)(NSArray *objects, NSError *error))callback;
- (void)fetchLeadersSortedByColumn:(NSString *)column withSkip:(long)skip callback:(void(^)(NSArray *objects, NSError *error))callback;
- (void)createOrUpdatePick:(Pick *)pick;

@end
