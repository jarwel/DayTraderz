//
//  AppDelegate.m
//  DayTrades
//
//  Created by Jason Wells on 1/9/15.
//  Copyright (c) 2015 Jason Wells. All rights reserved.
//

#import "AppDelegate.h"
#import "DayTrades-Swift.h"
#import "AppConstants.h"

@interface AppDelegate ()

@property (strong, nonatomic) Account *account;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"nejKNcGGrt7CFNrKoQm0rdRmGWju7LzY7mp6HI5M" clientKey:@"lK3DnrFO0M5oo4iNVvSafci6mh0vSZTjm5B3HdnO"];
    [Account registerSubclass];
    [Pick registerSubclass];

    UIViewController *currentViewController = [self currentViewController];
    [self.window setRootViewController:currentViewController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logIn) name:LogInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:LogOutNotification object:nil];
    if ([PFUser currentUser]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LogInNotification object:nil];
    }
    return YES;
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
    }
    
    NSString *title = @"Log In Error";
    NSString *message = @"Please fill out all of the information.";
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return NO;
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    if (!informationComplete) {
        NSString *title = @"Log In Error";
        NSString *message = @"Please fill out all of the information.";
        [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [[NSNotificationCenter defaultCenter] postNotificationName:LogInNotification object:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [ParseClient createAccount:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LogInNotification object:nil];
                }
            }];
        }
    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
}

- (void)logIn {
    [ParseClient fetchAccount:^(PFObject *object, NSError *error) {
        if (object) {
            self.account = (Account *)object;
            UIViewController *currentViewController = [self currentViewController];
            [self.window setRootViewController:currentViewController];
        }
    }];
}

- (void)logOut {
    [PFUser logOut];
    self.account = nil;
    [self.window setRootViewController:[self currentViewController]];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
}

- (UIViewController *)currentViewController {
    if (![PFUser currentUser]) {
        return self.signInViewController;
    }
    return self.homeViewController;
}

- (UIViewController *)signInViewController {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    [signUpViewController setDelegate:self];
    
    LogInViewController *logInViewController = [[LogInViewController alloc] init];
    [logInViewController setDelegate:self];
    [logInViewController setSignUpController:signUpViewController];
    return logInViewController;
}

- (UIViewController *)homeViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"AppController"];
    AccountViewController *accountViewController = [navigationController.childViewControllers firstObject];
    accountViewController.account = self.account;
    return navigationController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
