//
//  DateHelperTests.m
//  DayTrades
//
//  Created by Jason Wells on 7/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateHelper.h"

@interface DateHelperTests : XCTestCase

@property (strong, nonatomic) NSDateFormatter *utc;
@property (strong, nonatomic) NSDateFormatter *eastern;

@end

@implementation DateHelperTests

- (void)setUp {
    [super setUp];
    self.utc = [[NSDateFormatter alloc] init];
    [self.utc setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [self.utc setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    self.eastern = [[NSDateFormatter alloc] init];
    [self.eastern setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [self.eastern setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
}

- (void)tearDown {
    self.utc = nil;
    self.eastern = nil;
    [super tearDown];
}

- (void)testNextDayOfTradeFromDate {
    NSDate *date = [self.utc dateFromString:@"2015-07-09T04:29:00"];
    NSString *nextDayOfTrade = [[DateHelper instance] nextDayOfTradeFromDate:date];
    XCTAssertEqualObjects(nextDayOfTrade, @"2015-07-09");
}

- (void)testNextDayOfTradeBeforeMarketOpen {
    NSDate *date = [self.eastern dateFromString:@"2015-07-09T08:59:59"];
    NSString *nextDayOfTrade = [[DateHelper instance] nextDayOfTradeFromDate:date];
    XCTAssertEqualObjects(nextDayOfTrade, @"2015-07-09");
}

- (void)testNextDayOfTradeAfterMarketOpen {
    NSDate *date = [self.eastern dateFromString:@"2015-07-09T09:00:00"];
    NSString *nextDayOfTrade = [[DateHelper instance] nextDayOfTradeFromDate:date];
    XCTAssertEqualObjects(nextDayOfTrade, @"2015-07-10");
}

- (void)testMarketIsOpen {
    NSDate *date = [self.eastern dateFromString:@"2015-07-06T09:30:00"];
    BOOL isMarketOpen = [[DateHelper instance] isMarketOpenOnDate:date];
    XCTAssertTrue(isMarketOpen, @"isMarketOpen is NO");
}

- (void)testMarketIsClosed {
    NSDate *date = [self.eastern dateFromString:@"2015-07-05T09:30:00"];
    BOOL isMarketOpen = [[DateHelper instance] isMarketOpenOnDate:date];
    XCTAssertFalse(isMarketOpen, @"isMarketOpen is YES");
}

- (void)testMarketIsClosedOnHoliday {
    NSDate *date = [self.eastern dateFromString:@"2015-07-03T09:30:00"];
    BOOL isMarketOpen = [[DateHelper instance] isMarketOpenOnDate:date];
    XCTAssertFalse(isMarketOpen, @"isMarketOpen is YES");
}

@end
