//
//  PriceFormatter.m
//  DayTraderz
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "PriceFormatter.h"

@implementation PriceFormatter

+ (NSString *)changeFormat:(float)priceChange percentChange:(float)percentChange {
    NSString *priceChangeFormat = [NSString stringWithFormat:@"%+0.2f", priceChange];
    NSString *percentChangeFormat = [NSString stringWithFormat:@"%+0.2f%%", percentChange];
    return [NSString stringWithFormat:@"%@ (%@)", priceChangeFormat, percentChangeFormat];
}

+ (NSString *)valueFormat:(float)value {
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setCurrencyCode:@"USD"];
    NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithFloat:value];
    return [currencyFormatter stringFromNumber:decimalNumber];
}

+ (NSString *)changeFormatFromQuote:(Quote *)quote {
    return [self changeFormat:quote.priceChange percentChange:quote.percentChange];
}

+ (NSString *)changeFormatFromPick:(Pick *)pick {
    float priceChange = pick.close - pick.open;
    float percentChange = priceChange / pick.open * 100;
    return [self changeFormat:priceChange percentChange:percentChange];
}

+ (UIColor *)colorFromChange:(float)change {
    if (change > 0) {
        return [UIColor greenColor];
    }
    if (change < 0) {
        return [UIColor redColor];
    }
    return [UIColor blueColor];
}

@end
