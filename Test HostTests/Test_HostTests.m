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

- (void)testTyping
{
    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Tapping"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
                   matchingView:@{kFRYLookupAccessibilityLabel : @"Greeting"}];
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"Greeting"} whenFound:^(NSArray *lookupResults) {
        FRYLookupResult *lookupResult = [lookupResults lastObject];
        [[FRY shared] replaceTextWithString:@"Ohhi!" intoView:lookupResult.view];
    }];

    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
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
                                                       xyoffsets:0.409f,0.897f,0.000, 0.409f,0.897f,0.088]
                   matchingView:@{@"accessibilityLabel" : @"Tapping"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:3
                                                       xyoffsets:0.699f,0.784f,0.000, 0.699f,0.807f,0.041, 0.699f,0.807f,0.080]
                   matchingView:@{@"accessibilityLabel" : @"Second", @"accessibilityValue" : @""}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.410f,0.784f,0.000, 0.410f,0.784f,0.128]
                   matchingView:@{@"accessibilityLabel" : @"First", @"accessibilityValue" : @""}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:3
                                                       xyoffsets:0.840f,0.648f,0.000, 0.846f,0.648f,0.057, 0.846f,0.648f,0.080]
                   matchingView:@{@"accessibilityLabel" : @"Second", @"accessibilityValue" : @""}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:98
                                                       xyoffsets:0.135f,0.652f,0.000, 0.149f,0.696f,0.080, 0.162f,0.696f,0.097, 0.162f,0.739f,0.114, 0.176f,0.739f,0.132, 0.189f,0.739f,0.166, 0.216f,0.739f,0.184, 0.243f,0.696f,0.201, 0.284f,0.696f,0.218, 0.297f,0.696f,0.234, 0.311f,0.696f,0.252, 0.338f,0.696f,0.269, 0.351f,0.696f,0.290, 0.378f,0.696f,0.321, 0.405f,0.696f,0.339, 0.446f,0.696f,0.417, 0.500f,0.696f,0.436, 0.595f,0.696f,0.469, 0.622f,0.696f,0.488, 0.635f,0.696f,0.522, 0.622f,0.696f,0.632, 0.541f,0.696f,0.649, 0.365f,0.696f,0.667, 0.189f,0.696f,0.684, 0.149f,0.696f,0.701, 0.135f,0.696f,0.719, 0.149f,0.696f,0.744, 0.176f,0.696f,0.762, 0.216f,0.652f,0.779, 0.297f,0.609f,0.795, 0.419f,0.609f,0.813, 0.541f,0.609f,0.830, 0.595f,0.609f,0.848, 0.622f,0.565f,0.866, 0.608f,0.565f,0.904, 0.554f,0.565f,0.921, 0.500f,0.565f,0.938, 0.405f,0.565f,0.955, 0.270f,0.609f,0.971, 0.108f,0.609f,0.989, 0.041f,0.609f,1.005, 0.041f,0.652f,1.022, 0.081f,0.652f,1.039, 0.189f,0.652f,1.056, 0.297f,0.652f,1.073, 0.378f,0.652f,1.090, 0.432f,0.652f,1.107, 0.500f,0.652f,1.125, 0.568f,0.652f,1.142, 0.622f,0.652f,1.160, 0.662f,0.652f,1.177, 0.676f,0.652f,1.195, 0.649f,0.652f,1.216, 0.581f,0.652f,1.233, 0.459f,0.609f,1.251, 0.338f,0.609f,1.269, 0.257f,0.609f,1.285, 0.230f,0.609f,1.305, 0.230f,0.652f,1.322, 0.311f,0.652f,1.354, 0.365f,0.652f,1.371, 0.405f,0.609f,1.389, 0.500f,0.609f,1.406, 0.622f,0.609f,1.423, 0.703f,0.652f,1.439, 0.784f,0.652f,1.456, 0.811f,0.652f,1.473, 0.824f,0.652f,1.490, 0.838f,0.609f,1.508, 0.851f,0.609f,1.525, 0.865f,0.609f,1.632, 0.878f,0.609f,1.650, 0.892f,0.609f,1.666, 0.878f,0.609f,1.768, 0.811f,0.609f,1.787, 0.581f,0.565f,1.819, 0.541f,0.565f,1.837, 0.541f,0.522f,1.930, 0.581f,0.522f,1.947, 0.662f,0.522f,1.964, 0.770f,0.522f,1.981, 0.838f,0.522f,1.999, 0.892f,0.522f,2.016, 0.878f,0.522f,2.073, 0.865f,0.522f,2.152, 0.851f,0.522f,2.170, 0.811f,0.522f,2.186, 0.743f,0.522f,2.203, 0.689f,0.522f,2.220, 0.649f,0.522f,2.237, 0.595f,0.522f,2.256, 0.554f,0.565f,2.273, 0.527f,0.565f,2.290, 0.541f,0.565f,2.320, 0.554f,0.565f,2.339, 0.568f,0.522f,2.356, 0.581f,0.522f,2.424, 0.581f,0.522f,2.624]
                   matchingView:@{@"accessibilityLabel" : @"Slider", @"accessibilityValue" : @"0%"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:2
                                                       xyoffsets:0.745f,0.694f,0.000, 0.745f,0.694f,0.104]
                   matchingView:@{@"accessibilityLabel" : @"Happy", @"accessibilityValue" : @"1"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                          points:3
                                                       xyoffsets:0.333f,0.532f,0.000, 0.333f,0.500f,0.080, 0.333f,0.500f,0.096]
                   matchingView:@{@"accessibilityLabel" : @"Happy", @"accessibilityValue" : @"0"}];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

@end
