//
//  PickViewController.h
//  DayTraderz
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pick.h"

@protocol PickViewControllerDelegate <NSObject>

@required
- (void)pickFromController:(Pick *)pick;

@end

@interface PickViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) id<PickViewControllerDelegate> delegate;
@property (strong, nonatomic) Account *account;

@end
