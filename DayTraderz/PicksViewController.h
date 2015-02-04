//
//  PicksViewController.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pick.h"

@protocol PicksViewControllerDelegate <NSObject>

@required
- (void)pickFromController:(Pick *)pick;

@end

@interface PicksViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) id<PicksViewControllerDelegate> delegate;
@property (strong, nonatomic) Account *account;

@end
