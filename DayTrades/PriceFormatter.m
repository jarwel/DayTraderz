//
//  PriceFormatter.m
//  DayTrades
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PriceFormatter.h"

@implementation PriceFormatter

+ (NSString *)formatForValue:(float)value {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencyCode:@"USD"];
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithFloat:value];
    return [currencyFormatter stringFromNumber:decimalNumber];
}

+ (NSString *)formatForQuote:(Quote *)quote {
    return [self formatForPriceChange:quote.priceChange andPercentChange:quote.percentChange];
}

+ (NSString *)formatForPick:(Pick *)pick {
    float priceChange = pick.close - pick.open;
    float percentChange = priceChange / pick.open * 100;
    return [self formatForPriceChange:priceChange andPercentChange:percentChange];
}

+ (NSString *)formatForPriceChange:(float)priceChange andPercentChange:(float)percentChange {
    NSString *priceChangeFormat = [NSString stringWithFormat:@"%+0.2f", priceChange];
    NSString *percentChangeFormat = [NSString stringWithFormat:@"%+0.2f%%", percentChange];
    return [NSString stringWithFormat:@"%@ (%@)", priceChangeFormat, percentChangeFormat];
}

+ (UIColor *)colorForChange:(float)change {
    if (change > 0) {
        return [UIColor greenColor];
    }
    if (change < 0) {
        return [UIColor redColor];
    }
    return [UIColor lightGrayColor];
}

@end
