//
//  FinanceClient.m
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "FinanceClient.h"

@implementation FinanceClient

+ (FinanceClient *)instance {
    static FinanceClient *instance;
    if (! instance) {
        instance = [[FinanceClient alloc] init];
    }
    return instance;
}

- (void)fetchQuotesForSymbols:(NSSet *)symbols callback:(void (^)(NSURLResponse *response, NSData *data, NSError *error))callback {
    NSString *symbolString = [NSString stringWithFormat:@"'%@'", [[symbols allObjects] componentsJoinedByString:@"','"]];
    NSString *query = [NSString stringWithFormat:@"select symbol, Name, LastTradePriceOnly, Change, ChangeinPercent, PreviousClose, ErrorIndicationreturnedforsymbolchangedinvalid from yahoo.finance.quotes where symbol in (%@)", symbolString];
    NSString* encoded = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=%@&env=store://datatables.org/alltableswithkeys&format=json", encoded];
    
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:callback];
}

- (void)fetchQuoteForSymbol:(NSString *)symbol onDate:(NSString *)tradeDate callback:(void (^)(NSURLResponse *response, NSData *data, NSError *error))callback {
    NSString *query = [NSString stringWithFormat:@"select * from yahoo.finance.historicaldata where symbol = '%@' and startDate = '%@' and endDate = '%@'", symbol, tradeDate, tradeDate];
    NSString* encoded = [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=%@&env=store://datatables.org/alltableswithkeys&format=json", encoded];
    
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:callback];
}

@end
