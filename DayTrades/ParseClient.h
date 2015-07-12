//
//  ParseClient.h
//  DayTrades
//
//  Created by Jason Wells on 2/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DayTrades-Swift.h"

@interface ParseClient : NSObject

+ (ParseClient *)instance;
- (void)fetchAccountForUser:(PFUser *)user callback:(void(^)(NSObject *object, NSError *error))callback;
- (void)fetchPicksForAccount:(Account *)account withLimit:(int)limit withSkip:(long)skip callback:(void(^)(NSArray *objects, NSError *error))callback;
- (void)fetchAccountsSortedByColumn:(NSString *)column withLimit:(int)limit withSkip:(long)skip callback:(void(^)(NSArray *objects, NSError *error))callback;
- (void)createOrUpdatePick:(Pick *)pick;

@end
