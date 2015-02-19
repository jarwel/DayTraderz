//
//  DayQuote.m
//  DayTrades
//
//  Created by Jason Wells on 2/3/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "DayQuote.h"

@interface DayQuote ()

@property (strong, nonatomic) NSDictionary *dictionary;

@end

@implementation DayQuote

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.dictionary = dictionary;
    }
    return self;
}

- (NSString *)symbol {
    if (!_symbol) {
        self.symbol = [self.dictionary objectForKey:@"Symbol"];
    }
    return _symbol;
}

- (NSString *)date {
    if (!_date) {
        self.date = [self.dictionary objectForKey:@"Date"];
    }
    return _date;
}

- (float)open {
    if (_open == 0) {
        self.open = [[self.dictionary objectForKey:@"Open"] floatValue];
    }
    return _open;
}

- (float)close {
    if (_close == 0) {
        self.close = [[self.dictionary objectForKey:@"Close"] floatValue];
    }
    return _close;
}

+ (DayQuote *)fromData:(NSData *)data {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *query = [dictionary objectForKey:@"query"];
    int count = [[query objectForKey:@"count"] intValue];
    if (count == 1) {
        NSDictionary *results = [query objectForKey:@"results"];
        NSDictionary *dictionary = [results objectForKey:@"quote"];
        return [[DayQuote alloc] initWithDictionary:dictionary];
    }
    return nil;
}

@end
