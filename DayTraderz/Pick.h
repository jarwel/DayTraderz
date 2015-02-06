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
@property (strong, nonatomic) NSString *tradeDate;
@property (strong, nonatomic) NSString *symbol;
@property (assign, nonatomic) float open;
@property (assign, nonatomic) float close;
@property (assign, nonatomic) float shares;
@property (assign, nonatomic) float value;
@property (assign, nonatomic) float change;


+ (NSString *)parseClassName;
+ (Pick *)initForAccount:(Account *)account withSymbol:(NSString *)symbol withDate:(NSString *)date;

@end
