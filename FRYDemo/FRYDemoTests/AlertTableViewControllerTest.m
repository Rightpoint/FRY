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

typedef void(^Foo)(NSString *name, ...);

#import "AlertTableViewController.h"

@interface AlertTableViewControllerTest : XCTestCase

@property (strong, nonatomic) AlertTableViewController *viewController;

@end

@implementation AlertTableViewControllerTest

+ (void)load
{
    [[FRYTouchHighlightWindowLayer shared] enable];
}

- (void)setUp
{
    [super setUp];
    self.viewController = [[AlertTableViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.viewController;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}


- (void)testBasic
{
    for ( NSString *label in @[@"One", @"Two", @"Three"] ) {
        FRY.lookupFirstByAccessibilityLabel(label).tap();
        FRY.lookupFirstByAccessibilityLabel(@"OK").tap();
    }
}

- (void)testBasicActions
{
    for ( NSString *response in @[@"Destructive", @"Other", @"OK"] ) {
        FRY.lookupFirstByAccessibilityLabel(@"Action One").tap();
        FRY.lookupFirstByAccessibilityLabel(response).tap();
    }
}

@end
