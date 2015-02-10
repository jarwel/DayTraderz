//
//  DateHelper.h
//  DayTraderz
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate *)nextTradeDate;
+ (NSDate *)lastTradeDate;
+ (NSString *)tradeDateFormat:(NSDate *)tradeDate;

@end
