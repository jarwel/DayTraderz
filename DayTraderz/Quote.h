//
//  Quote.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (nonatomic, strong, readonly) NSString *symbol;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) float price;
@property (nonatomic, assign, readonly) float priceChange;
@property (nonatomic, assign, readonly) float percentChange;
@property (nonatomic, assign, readonly) float open;
@property (nonatomic, assign, readonly) float previousClose;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (Quote *)fromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)fromData:(NSData *)data;

@end
