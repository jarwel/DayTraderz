//
//  PriceFormatter.h
//  DayTrades
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pick.h"
#import "Quote.h"

@interface PriceFormatter : NSObject

+ (NSString *)formatForValue:(float)value;
+ (NSString *)formatForQuote:(Quote *)quote;
+ (NSString *)formatForPick:(Pick *)pick;
+ (NSString *)formatForPriceChange:(float)priceChange andPercentChange:(float)percentChange;
+ (UIColor *)colorForChange:(float)change;

@end
