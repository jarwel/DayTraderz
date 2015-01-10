//
//  FinanceClient.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinanceClient : NSObject

+ (FinanceClient *)instance;
- (void)fetchQuotesForSymbols:(NSSet *)symbols callback:(void (^)(NSURLResponse *response, NSData *data, NSError *error))callback;

@end
