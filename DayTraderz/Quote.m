//
//  Quote.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "Quote.h"

@interface Quote ()

@property (strong, nonatomic) NSDictionary *dictionary;

@end


@implementation Quote

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.dictionary = dictionary;
    }
    return self;
}

- (NSString *)symbol {
    if (!_symbol) {
        self.symbol = [self.dictionary objectForKey:@"symbol"];
    }
    return _symbol;
}

- (NSString *)name {
    if (!_name) {
        self.name = [self.dictionary objectForKey:@"Name"];
    }
    return _name;
}

- (float)price {
    if (_price == 0) {
        if ([self.dictionary objectForKey:@"LastTradePriceOnly"] != [NSNull null]) {
            self.price = [[self.dictionary objectForKey:@"LastTradePriceOnly"] floatValue];
        }
    }
    return _price;
}

- (float)priceChange {
    if (_priceChange == 0) {
        if ([self.dictionary objectForKey:@"Change"] != [NSNull null]) {
            self.priceChange = [[self.dictionary objectForKey:@"Change"] floatValue];
        }
    }
    return _priceChange;
}

- (float)percentChange {
    if (_percentChange == 0) {
        if ([self.dictionary objectForKey:@"ChangeinPercent"] != [NSNull null]) {
            self.percentChange = [[self.dictionary objectForKey:@"ChangeinPercent"] floatValue];
        }
    }
    return _percentChange;
}

- (float)open {
    if (_open == 0) {
        if ([self.dictionary objectForKey:@"Open"] != [NSNull null]) {
            self.open = [[self.dictionary objectForKey:@"Open"] floatValue];
        }
    }
    return _open;
}

+ (Quote *)fromDictionary:(NSDictionary *)dictionary {
    if ([dictionary objectForKey:@"ErrorIndicationreturnedforsymbolchangedinvalid"] == [NSNull null]) {
        return [[Quote alloc] initWithDictionary:dictionary];
    }
    return nil;
}

+ (NSArray *)fromData:(NSData *)data {
    NSMutableArray *quotes = [[NSMutableArray alloc] init];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *query = [dictionary objectForKey:@"query"];
    int count = [[query objectForKey:@"count"] intValue];
    if (count == 1) {
        NSDictionary *results = [query objectForKey:@"results"];
        NSDictionary *dictionary = [results objectForKey:@"quote"];
        Quote* quote = [Quote fromDictionary:dictionary];
        if (quote) {
            [quotes addObject:quote];
        }
    }
    if (count > 1) {
        NSDictionary *results = [query objectForKey:@"results"];
        for (NSDictionary *dictionary in [results objectForKey:@"quote"]) {
            Quote* quote = [Quote fromDictionary:dictionary];
            if (quote) {
                [quotes addObject:quote];
            }
        }
    }
    return quotes;
}

@end
