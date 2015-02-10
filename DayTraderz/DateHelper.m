//
//  DateHelper.m
//  DayTraderz
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSDate *)nextTradeDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *date = [NSDate date];
    if ([calendar components:NSCalendarUnitHour fromDate:date].hour >= 14) {
        long weekDay;
        do {
            date = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
            weekDay = [[calendar components:NSCalendarUnitWeekday fromDate:date] weekday];
        }
        while (weekDay < 1 || weekDay > 6 );
    }
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    components.hour = 14;
    components.minute = 30;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)lastTradeDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *date = [NSDate date];
    if ([calendar components:NSCalendarUnitHour fromDate:date].hour <= 14) {
        long weekDay;
        do {
            date = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
            weekDay = [[calendar components:NSCalendarUnitWeekday fromDate:date] weekday];
        }
        while (weekDay < 1 || weekDay > 6 );
    }
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    components.hour = 14;
    components.minute = 30;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

+ (NSString *)tradeDateFormat:(NSDate *)tradeDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, yyyy"];
    return [formatter stringFromDate:tradeDate];
}

@end
