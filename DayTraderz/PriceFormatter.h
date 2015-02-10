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

+ (NSString *)formattedChangeFromQuote:(Quote *)quote;
+ (NSString *)formattedChangeFromPick:(Pick *)pick;
+ (UIColor *)colorForChange:(float)change;

@end
