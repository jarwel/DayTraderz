//
//  Quote.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) float price;
@property (assign, nonatomic) float priceChange;
@property (assign, nonatomic) float percentChange;
@property (assign, nonatomic) float open;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)fromData:(NSData *)data;
+ (Quote *)fromDictionary:(NSDictionary *)dictionary;

@end
