//
//  PriceFormatter.h
//  DayTrades
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayTrades-Swift.h"
#import "Pick.h"

@interface PriceFormatter : NSObject

+ (NSString *)formatForValue:(float)value;
+ (NSString *)formatForQuote:(Quote *)quote;
+ (NSString *)formatForPick:(Pick *)pick;
+ (NSString *)formatForPriceChange:(float)priceChange andPercentChange:(float)percentChange;

@end
