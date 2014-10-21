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
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.335f,0.586f,0.000, 0.335f,0.586f,0.112]
                   matchingView:@{@"accessibilityLabel" : @"Tapping"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.686f,0.864f,0.000, 0.686f,0.864f,0.112]
                   matchingView:@{@"accessibilityValue" : @"", @"accessibilityLabel" : @"Second"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.231f,0.716f,0.000, 0.231f,0.716f,0.112]
                   matchingView:@{@"accessibilityValue" : @"", @"accessibilityLabel" : @"First"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:16
                                                       xyoffsets:0.182f,0.891f,0.000, 0.196f,0.891f,0.026, 0.209f,0.891f,0.044, 0.223f,0.891f,0.062, 0.236f,0.891f,0.079, 0.264f,0.891f,0.097, 0.291f,0.891f,0.114, 0.331f,0.891f,0.131, 0.372f,0.891f,0.147, 0.412f,0.891f,0.166, 0.426f,0.891f,0.184, 0.439f,0.891f,0.203, 0.459f,0.891f,0.474, 0.466f,0.891f,0.498, 0.480f,0.891f,0.515, 0.480f,0.891f,0.676]
                   matchingView:@{@"accessibilityValue" : @"0%", @"accessibilityLabel" : @"Slider"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.618f,0.855f,0.000, 0.618f,0.855f,0.113]
                   matchingView:@{@"accessibilityValue" : @"1", @"accessibilityLabel" : @"Happy"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.353f,0.790f,0.000, 0.353f,0.790f,0.102]
                   matchingView:@{@"accessibilityValue" : @"0", @"accessibilityLabel" : @"Happy"}];

    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.264f,0.645f,0.000, 0.264f,0.645f,0.104]
                   matchingView:@{@"accessibilityLabel" : @"Slightly Offscreen Button"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.586f,0.516f,0.000, 0.586f,0.516f,0.096]
                   matchingView:@{@"accessibilityLabel" : @"X"}];

    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

@end
