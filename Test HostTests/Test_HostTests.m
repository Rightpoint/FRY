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
#import "FRYSimulatedTouch.h"
#import "FRYRecordedTouch.h"

@interface Test_HostTests : XCTestCase


@end

@implementation Test_HostTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    XCTAssertFalse([[FRY shared] hasActiveInteractions]);
    XCTAssertFalse([[FRY shared] hasActiveTouches]);
    [[FRY shared] clearInteractionsAndTouches];
    [super tearDown];
}

- (void)testAccessibilityLabelLookup
{
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

- (void)testAlertViews
{
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"UIAlertView"}];
    
    // Wait For Animations
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Cancel"}];

    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
}

- (void)testTapping
{
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Tapping"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"First"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Second"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"First"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Happy"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"X"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Slightly Offscreen Button"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    __block BOOL found = NO;
    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"1"} whenFound:^(NSArray *lookupResults) {
        found = YES;
    }];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    XCTAssertTrue(found);
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Label with Tap Gesture Recognizer"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    
    found = NO;
    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"2"} whenFound:^(NSArray *lookupResults) {
        found = YES;
    }];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    XCTAssertTrue(found);


    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Test Suite"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

}


- (void)testRecording
{
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0
                                                          points:2
                                                       xyoffsets:0.344,0.701,0.000, 0.344,0.701,0.104]
                   matchingView:@{@"accessibilityLabel" : @"Tapping"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] simulateTouch:[FRYRecordedTouch touchStarting:1.5
                                                         points:2
                                                      xyoffsets:62.500,48.000,0.000, 62.500,48.000,0.080]
                   matchingView:nil];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

@end
