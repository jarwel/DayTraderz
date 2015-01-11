//
//  Quote.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (strong, nonatomic, readonly) NSString *symbol;
@property (strong, nonatomic, readonly) NSString *name;
@property (assign, nonatomic, readonly) float price;
@property (assign, nonatomic, readonly) float priceChange;
@property (assign, nonatomic, readonly) float percentChange;
@property (assign, nonatomic, readonly) float open;
@property (assign, nonatomic, readonly) float previousClose;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (Quote *)fromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)fromData:(NSData *)data;

@end
