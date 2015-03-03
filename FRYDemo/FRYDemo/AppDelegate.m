//
//  AppDelegate.m
//  TestTarget
//
//  Created by Brian King on 11/2/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "AppDelegate.h"
#import "ControlsViewController.h"
#import "TableViewController.h"
#import "AlertTableViewController.h"
#import "TextFieldViewController.h"
#import "PickerViewController.h"
#import "WebViewController.h"

#import <FRYolator/FRYolator.h>
#import <FRY/FRY.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (UIViewController *)navigationControllerContaining:(Class)klass
{
    UIViewController *vc = [[klass alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    return navigationController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UITabBarController *tabController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
    tabController.viewControllers = @[
                                      [self navigationControllerContaining:[ControlsViewController class]],
                                      [self navigationControllerContaining:[TableViewController class]],
                                      [self navigationControllerContaining:[AlertTableViewController class]],
                                      [self navigationControllerContaining:[TextFieldViewController class]],
                                      [self navigationControllerContaining:[PickerViewController class]],
                                      [self navigationControllerContaining:[WebViewController class]],
                                      ];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];
    [[FRYolatorUI shared] registerGestureEnablingOnView:self.window];
    
    return YES;
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

#pragma mark - Split view

@end
