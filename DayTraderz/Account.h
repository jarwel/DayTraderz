//
//  Account.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Account : PFObject<PFSubclassing>

@property (assign, nonatomic) PFUser *user;
@property (assign, nonatomic) float value;

+ (void)load;
+ (NSString *)parseClassName;
+ (Account *)initWithUser:(PFUser *)user;

@end
