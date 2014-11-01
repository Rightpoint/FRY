//
//  Test_HostTests.m
//  Test HostTests
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRYTouchDispatch.h"

@interface Test_HostTests : XCTestCase


@end

@implementation Test_HostTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    XCTAssertFalse([[FRYTouchDispatch shared] hasActiveTouches]);
    [[FRYTouchDispatch shared] clearInteractionsAndTouches];
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
}

@end
