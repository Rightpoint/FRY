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
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:1.061
                                                          points:2
                                                       xyoffsets:0.368f,0.782f,0.000, 0.368f,0.782f,0.072]
                   matchingView:@{@"accessibilityLabel" : @"Tapping"}];
    
    [[FRY shared] simulateTouch:[FRYRecordedTouch touchStarting:1.911
                                                         points:2
                                                      xyoffsets:172.500f,118.500f,0.000, 172.500f,118.500f,0.064]
                   matchingView:nil];
    
    [[FRY shared] simulateTouch:[FRYRecordedTouch touchStarting:2.353
                                                         points:2
                                                      xyoffsets:107.500f,120.500f,0.000, 106.500f,120.500f,0.104]
                   matchingView:nil];
    
    [[FRY shared] simulateTouch:[FRYRecordedTouch touchStarting:3.473
                                                         points:2
                                                      xyoffsets:183.500f,110.000f,0.000, 183.500f,110.000f,0.080]
                   matchingView:nil];
    
    [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:4.207
                                                          points:93
                                                       xyoffsets:0.196f,0.761f,0.000, 0.223f,0.761f,0.104, 0.250f,0.761f,0.121, 0.297f,0.761f,0.138, 0.324f,0.761f,0.155, 0.351f,0.761f,0.172, 0.378f,0.761f,0.189, 0.419f,0.761f,0.207, 0.466f,0.761f,0.223, 0.480f,0.761f,0.241, 0.514f,0.761f,0.258, 0.500f,0.761f,0.472, 0.466f,0.761f,0.490, 0.439f,0.761f,0.507, 0.412f,0.761f,0.524, 0.385f,0.761f,0.541, 0.372f,0.761f,0.559, 0.392f,0.761f,0.721, 0.419f,0.761f,0.739, 0.459f,0.717f,0.756, 0.486f,0.717f,0.774, 0.514f,0.717f,0.791, 0.547f,0.717f,0.808, 0.561f,0.717f,0.826, 0.574f,0.717f,0.843, 0.588f,0.717f,0.861, 0.608f,0.717f,0.878, 0.595f,0.717f,0.994, 0.561f,0.717f,1.011, 0.507f,0.717f,1.028, 0.439f,0.674f,1.045, 0.378f,0.587f,1.062, 0.324f,0.543f,1.079, 0.284f,0.478f,1.097, 0.257f,0.478f,1.114, 0.243f,0.478f,1.131, 0.257f,0.478f,1.276, 0.270f,0.478f,1.580, 0.284f,0.478f,1.597, 0.311f,0.478f,1.614, 0.351f,0.478f,1.631, 0.378f,0.435f,1.648, 0.405f,0.435f,1.665, 0.439f,0.435f,1.683, 0.453f,0.435f,1.700, 0.480f,0.435f,1.717, 0.507f,0.435f,1.734, 0.534f,0.435f,1.753, 0.561f,0.435f,1.770, 0.574f,0.435f,1.789, 0.635f,0.435f,1.821, 0.642f,0.435f,1.837, 0.655f,0.435f,1.854, 0.669f,0.435f,1.871, 0.682f,0.435f,2.166, 0.696f,0.435f,2.183, 0.709f,0.435f,2.200, 0.723f,0.435f,2.217, 0.736f,0.435f,2.234, 0.750f,0.435f,2.253, 0.757f,0.435f,2.270, 0.770f,0.435f,2.294, 0.757f,0.435f,2.534, 0.743f,0.435f,2.558, 0.730f,0.435f,2.575, 0.689f,0.435f,2.593, 0.676f,0.435f,2.610, 0.649f,0.435f,2.628, 0.642f,0.435f,2.646, 0.628f,0.435f,2.702, 0.615f,0.435f,2.720, 0.601f,0.435f,2.737, 0.581f,0.435f,2.753, 0.574f,0.435f,2.776, 0.588f,0.435f,2.920, 0.615f,0.435f,2.937, 0.655f,0.435f,2.954, 0.689f,0.435f,2.971, 0.716f,0.435f,2.987, 0.730f,0.435f,3.004, 0.743f,0.435f,3.022, 0.757f,0.435f,3.039, 0.764f,0.435f,3.056, 0.777f,0.435f,3.074, 0.797f,0.435f,3.091, 0.804f,0.435f,3.128, 0.811f,0.435f,3.570, 0.824f,0.435f,3.594, 0.831f,0.435f,3.619, 0.838f,0.435f,3.650, 0.851f,0.435f,3.690, 0.858f,0.435f,3.722, 0.858f,0.435f,4.124]
                   matchingView:@{@"accessibilityLabel" : @"Slider", @"accessibilityValue" : @"0%"}];
    
    [[FRY shared] simulateTouch:[FRYRecordedTouch touchStarting:9.871
                                                         points:2
                                                      xyoffsets:134.000f,203.000f,0.000, 134.000f,203.000f,0.089]
                   matchingView:nil];
    
    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreCompleteWithTimeout:100];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
}

@end
