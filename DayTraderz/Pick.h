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
@property (strong, nonatomic) NSNumber *priceBought;
@property (strong, nonatomic) NSNumber *priceSold;
@property (strong, nonatomic) NSNumber *accountValue;

+ (NSString *)parseClassName;
+ (Pick *)initForAccount:(Account *)account withSymbol:(NSString *)symbol;

@end
