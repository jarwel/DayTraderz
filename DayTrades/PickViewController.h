//
//  PickViewController.h
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayTrades-Swift.h"

@protocol PickViewControllerDelegate <NSObject>

@required
- (void)updateNextPick:(Pick *)pick;

@end

@interface PickViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) id<PickViewControllerDelegate> delegate;
@property (strong, nonatomic) Account *account;

@end
