//
//  Test_HostTests.m
//  Test HostTests
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRY.h"
#import "FRYLookupResult.h"
#import "NSRunLoop+FRY.h"

@interface Test_HostTests : XCTestCase


@end

@implementation Test_HostTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    XCTAssertFalse([[FRY shared] hasActiveInteractions]);
    XCTAssertFalse([[FRY shared] hasActiveTouches]);
    [[FRY shared] clearInteractionsAndTouches];
    [super tearDown];
}

- (void)testAccessibilityLabelLookup {
    XCTestExpectation *lookupDone = [self expectationWithDescription:@"Lookup Complete"];
    __block UIView *foundView;
    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}
                          whenFound:^(NSArray *lookupResults) {
                              FRYLookupResult *result = [lookupResults lastObject];
                              foundView = result.view;
                              [lookupDone fulfill];
                          }];
    [self waitForExpectationsWithTimeout:0.5 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    XCTAssertNotNil(foundView);
    XCTAssertEqualObjects(@"Tapping", [foundView accessibilityLabel]);
}

- (void)testTap {
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"UIAlertView"}];
    
    // Wait For Animations
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Cancel"}];

    // Wait For Animations
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Tapping"}];

    [[NSRunLoop currentRunLoop] fry_runUntilEventsAndLookupsComplete];

    // Wait For Animations
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Test Suite"}];

    [[NSRunLoop currentRunLoop] fry_runUntilEventsAndLookupsComplete];
    
    // Wait For Animations
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];

    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}
                          whenFound:^(NSArray *lookupResults) {}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsAndLookupsComplete];



}

@end
