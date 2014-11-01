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

@interface Test_HostTests : XCTestCase


@end

@implementation Test_HostTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    if ([[FRYTouchDispatch shared] hasActiveTouches]) {
        [[FRYTouchDispatch shared] clearInteractionsAndTouches];
        XCTAssertFalse(YES);
    }
    
    [super tearDown];
}

- (void)testAccessibilityLabelLookup
{
    __block UIView *foundView;

    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          foundView = view;
                                      }];


    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    XCTAssertNotNil(foundView);
    XCTAssertEqualObjects(@"Tapping", [foundView accessibilityLabel]);
}

- (void)testAlertViews
{
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"UIAlertView"}];

    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Cancel"}];

    [[NSRunLoop currentRunLoop] fry_waitForIdle];
}

- (void)testTyping
{
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}];
    
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"Greeting"}
                                      usingBlock:^(UIView *textField, CGRect frameInView) {
                                          [textField fry_simulateTouch:[FRYSyntheticTouch tap] insideRect:frameInView];
                                          [[NSRunLoop currentRunLoop] fry_waitForIdle];
                                          [(UITextField *)textField fry_replaceTextWithString:@"Ohhi!"];
                                          [[NSRunLoop currentRunLoop] fry_waitForIdle];
                                      }];
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Test Suite"}];
    
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
}

- (void)testTapping
{
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"First"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Second"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"First"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Happy"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"X"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    // Ensure the view is not found
    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"1"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNil(view);
                                      }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Slightly Offscreen Button"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"1"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Label with Tap Gesture Recognizer"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"2"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];


    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:@{kFRYLookupAccessibilityLabel : @"Test Suite"}];
  
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
}


- (void)testRecording
{
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.182f,0.483f,0.000, 0.182f,0.483f,0.086]
             onSubviewMatching:@{@"accessibilityLabel" : @"Tapping"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.737f,0.830f,0.000, 0.737f,0.830f,0.064]
             onSubviewMatching:@{@"accessibilityLabel" : @"Second", @"accessibilityValue" : @""}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.510f,0.500f,0.000, 0.510f,0.500f,0.057]
             onSubviewMatching:@{@"accessibilityLabel" : @"Happy", @"accessibilityValue" : @"1"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:17
                                                      xyoffsets:0.243f,0.739f,0.000, 0.257f,0.739f,0.048, 0.297f,0.739f,0.067, 0.392f,0.739f,0.100, 0.419f,0.739f,0.117, 0.446f,0.739f,0.134, 0.459f,0.739f,0.352, 0.473f,0.739f,0.369, 0.486f,0.739f,0.409, 0.500f,0.739f,0.426, 0.514f,0.739f,0.443, 0.541f,0.739f,0.460, 0.568f,0.739f,0.478, 0.581f,0.739f,0.495, 0.595f,0.739f,0.513, 0.608f,0.739f,0.530, 0.608f,0.739f,0.778]
             onSubviewMatching:@{@"accessibilityLabel" : @"Slider", @"accessibilityValue" : @"0%"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.234f,0.727f,0.000, 0.234f,0.727f,0.096]
             onSubviewMatching:@{@"accessibilityLabel" : @"Test Suite"}];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
}

@end
