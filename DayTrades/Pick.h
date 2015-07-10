//
//  Pick.h
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Account.h"

@interface Pick : PFObject<PFSubclassing>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) NSString *dayOfTrade;
@property (strong, nonatomic) NSString *symbol;
@property (assign, nonatomic, readonly) double open;
@property (assign, nonatomic, readonly) double close;
@property (assign, nonatomic, readonly) double value;
@property (assign, nonatomic, readonly) double change;
@property (assign, nonatomic, readonly) BOOL processed;

+ (NSString *)parseClassName;
- (id)initForAccount:(Account *)account withSymbol:(NSString *)symbol withDayOfTrade:(NSString *)dayOfTrade;

@end
