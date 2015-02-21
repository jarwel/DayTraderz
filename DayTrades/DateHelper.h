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
- (NSDate *)nextTradeDate;
- (NSDate *)lastTradeDate;
- (NSString *)dayFormatForDate:(NSDate *)date;
- (NSString *)fullFormatForDate:(NSDate *)date;

@end
