//
//  DateHelper.h
//  DayTrades
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (DateHelper *)instance;
- (BOOL)isMarketOpenOnDate:(NSDate *)date;
- (NSString *)nextDayOfTradeFromDate:(NSDate *)date;
- (NSString *)lastDayOfTradeFromDate:(NSDate *)date;
- (NSString *)shortFormatForDayOfTrade:(NSString *)dayOfTrade;
- (NSString *)longFormatForDayOfTrade:(NSString *)dayOfTrade;

@end
