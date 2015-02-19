//
//  Account.h
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Account : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *user;
@property (assign, nonatomic) float value;
@property (assign, nonatomic) int winners;
@property (assign, nonatomic) int losers;

+ (NSString *)parseClassName;
- (id)initForUser:(PFUser *)user;

@end
