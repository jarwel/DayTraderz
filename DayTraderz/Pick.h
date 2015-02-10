//
//  Pick.h
//  DayTraderz
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
@property (strong, nonatomic) NSDate *tradeDate;
@property (strong, nonatomic) NSString *symbol;
@property (assign, nonatomic, readonly) float open;
@property (assign, nonatomic, readonly) float close;
@property (assign, nonatomic, readonly) float shares;
@property (assign, nonatomic, readonly) float value;
@property (assign, nonatomic, readonly) float change;


+ (NSString *)parseClassName;
- (id)initForAccount:(Account *)account withSymbol:(NSString *)symbol withDate:(NSDate *)date;

@end
