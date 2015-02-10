//
//  PriceFormatter.m
//  DayTraderz
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PriceFormatter.h"

@implementation PriceFormatter

+ (NSString *)formattedChange:(float)priceChange percentChange:(float)percentChange {
    NSString *priceChangeFormat = [NSString stringWithFormat:@"%+0.2f", priceChange];
    NSString *percentChangeFormat = [NSString stringWithFormat:@"%+0.2f%%", percentChange];
    return [NSString stringWithFormat:@"%@ (%@)", priceChangeFormat, percentChangeFormat];
}

+ (NSString *)formattedChangeFromQuote:(Quote *)quote {
    return [self formattedChange:quote.priceChange percentChange:quote.percentChange];
}

+ (NSString *)formattedChangeFromPick:(Pick *)pick {
    float priceChange = pick.close - pick.open;
    float percentChange = priceChange / pick.open;
    return [self formattedChange:priceChange percentChange:percentChange];
}

+ (UIColor *)colorForChange:(float)change {
    if (change > 0) {
        return [UIColor greenColor];
    }
    if (change < 0) {
        return [UIColor redColor];
    }
    return [UIColor blueColor];
}

@end
