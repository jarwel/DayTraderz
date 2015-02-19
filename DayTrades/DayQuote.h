//
//  DayQuote.h
//  DayTrades
//
//  Created by Jason Wells on 2/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayQuote : NSObject

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) float open;
@property (assign, nonatomic) float close;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (DayQuote *)fromData:(NSData *)data;

@end
