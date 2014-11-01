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
    XCTAssertFalse([[FRY shared] hasActiveTouches]);
    [[FRY shared] clearInteractionsAndTouches];
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
    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"UIAlertView"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          [view fry_simulateTouch:[FRYSyntheticTouch tap] insideRect:frameInView];
                                      }];

    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"Cancel"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          [view fry_simulateTouch:[FRYSyntheticTouch tap] insideRect:frameInView];
                                      }];

    [[NSRunLoop currentRunLoop] fry_waitForIdle];
}

- (void)testTyping
{
    [FRY_KEY fry_enumerateDepthFirstViewMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          [view fry_simulateTouch:[FRYSyntheticTouch tap] insideRect:frameInView];
                                      }];
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
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"Tapping"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//    
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"First"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"Second"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"First"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//    
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"Happy"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"X"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"Slightly Offscreen Button"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//
//    __block BOOL found = NO;
//    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"1"} whenFound:^(NSArray *lookupResults) {
//        found = YES;
//    }];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//    XCTAssertTrue(found);
//    
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"Label with Tap Gesture Recognizer"}];
//    [[NSRunLoop currentRunLoop] fry_waitForIdle];
//    
//    found = NO;
//    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"2"} whenFound:^(NSArray *lookupResults) {
//        found = YES;
//    }];
//    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];
//    XCTAssertTrue(found);
//
//
//    [[FRY shared] simulateTouch:[FRYSyntheticTouch tap]
//                   matchingView:@{kFRYLookupAccessibilityLabel : @"Test Suite"}];
//    
//    [[NSRunLoop currentRunLoop] fry_runUntilEventsLookupsAndAnimationsAreComplete];

}


- (void)testRecording
{
}

@end
