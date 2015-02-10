//
//  PriceFormatter.h
//  DayTraderz
//
//  Created by Jason Wells on 2/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pick.h"
#import "Quote.h"

@interface PriceFormatter : NSObject

+ (NSString *)valueFormat:(float)value;
+ (NSString *)changeFormatFromQuote:(Quote *)quote;
+ (NSString *)changeFormatFromPick:(Pick *)pick;
+ (UIColor *)colorFromChange:(float)change;

@end
