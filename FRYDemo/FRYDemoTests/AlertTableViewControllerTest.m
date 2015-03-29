//
//  AlertTableViewControllerTest.m
//  FRY
//
//  Created by Brian King on 11/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FRY/FRY.h>
#import <FRY/FRYolator.h>

#import "AlertTableViewController.h"

@interface AlertTableViewControllerTest : XCTestCase

@property (strong, nonatomic) AlertTableViewController *viewController;

@end

@implementation AlertTableViewControllerTest

+ (void)load
{
    [[FRYTouchHighlightWindowLayer shared] enable];
}

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
    for ( NSString *label in @[@"One", @"Two", @"Three"] ) {
        FRY.accessibilityLabel(label).tap();
        // The alertview is shown .5 seconds after tap, so wait a second for it to appear.
        FRY.accessibilityLabel(@"OK").tap().absent();
    }
}

- (void)testBasicActions
{

    for ( NSString *response in @[@"Destructive", @"Other", @"OK"] ) {
        FRY.accessibilityLabel(@"Action One").tap();
        FRY.accessibilityLabel(response).tap().absent();
    }
}

@end
