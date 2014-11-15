//
//  AlertTableViewControllerTest.m
//  FRY
//
//  Created by Brian King on 11/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AlertTableViewController.h"
#import "FRY.h"

@interface AlertTableViewControllerTest : XCTestCase

@property (strong, nonatomic) AlertTableViewController *viewController;

@end

@implementation AlertTableViewControllerTest

- (void)setUp {
    [super setUp];
    self.viewController = [[AlertTableViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.viewController;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:450000]];
}

- (void)tearDown {
    if ([[FRYTouchDispatch shared] hasActiveTouches]) {
        [[FRYTouchDispatch shared] clearInteractionsAndTouches];
        XCTAssertFalse(YES);
    }
    
    [super tearDown];
}



- (void)testBasic
{
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    for ( NSString *label in @[@"One", @"Two", @"Three"] ) {
        FRY_KEY.accessibilityLabel(label).depthFirst().tap();
        FRY_KEY.accessibilityLabel(@"OK").depthFirst().tap();
    }
}

- (void)testBasicActions
{

    for ( NSString *response in @[@"Destructive", @"Other", @"OK"] ) {
        FRY_KEY.accessibilityLabel(@"Action One").depthFirst().tap();
        FRY_KEY.accessibilityLabel(response).depthFirst().tap();
    }
}

@end
