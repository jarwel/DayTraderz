//
//  DateHelper.m
//  DayTrades
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "DateHelper.h"

@interface DateHelper ()

@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSArray *holidays;

@end

@implementation DateHelper

+ (DateHelper *)instance {
    static DateHelper *instance;
    if (!instance) {
        instance = [[DateHelper alloc] init];
        instance.holidays = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MarketHolidays"];
        instance.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [instance.calendar setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    }
    return instance;
}

- (NSString *)tradeDateFormat:(NSDate *)tradeDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    return [formatter stringFromDate:tradeDate];
}

- (NSDate *)nextTradeDate {
    NSDate *date = [NSDate date];

    long hour = [self.calendar components:NSCalendarUnitHour fromDate:date].hour;
    if (hour >= 9 || [self isInvalideTradeDate:date]) {
        do {
            date = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
        }
        while ([self isInvalideTradeDate:date]);
    }
    
    return [self tradeDateFromDate:date];
}

- (NSDate *)lastTradeDate {
    NSDate *date = [NSDate date];

    long hour = [self.calendar components:NSCalendarUnitHour fromDate:date].hour;
    if (hour < 9) {
        do {
            date = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
        }
        while ([self isInvalideTradeDate:date]);
    }
    
    return [self tradeDateFromDate:date];
}

- (BOOL)isInvalideTradeDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:( NSCalendarUnitWeekday) fromDate:date];
    return components.weekday < 2 && components.weekday > 6 && ![self.holidays containsObject:date];
}

- (NSDate *)tradeDateFromDate:(NSDate *)date {
    unsigned unitFlags = NSCalendarUnitTimeZone | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:date];
    components.hour = 9;
    components.minute = 30;
    components.second = 0;
    return [self.calendar dateFromComponents:components];
}

@end
