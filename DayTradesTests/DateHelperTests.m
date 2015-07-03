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

@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation DateHelperTests

- (void)setUp {
    [super setUp];
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"yyyy-MM-dd"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testMarketIsOpen {
    NSDate *date = [self.formatter dateFromString:@"2015-07-06"];
    BOOL isMarketOpen = [[DateHelper instance] isMarketOpenOnDate:date];
    XCTAssertTrue(isMarketOpen, @"isMarketOpen is NO");
}

- (void)testMarketIsClosed {
    NSDate *date = [self.formatter dateFromString:@"2015-07-05"];
    BOOL isMarketOpen = [[DateHelper instance] isMarketOpenOnDate:date];
    XCTAssertFalse(isMarketOpen, @"isMarketOpen is YES");
}

- (void)testMarketIsClosedOnHoliday {
    NSDate *date = [self.formatter dateFromString:@"2015-07-03"];
    BOOL isMarketOpen = [[DateHelper instance] isMarketOpenOnDate:date];
    XCTAssertFalse(isMarketOpen, @"isMarketOpen is YES");
}

@end
