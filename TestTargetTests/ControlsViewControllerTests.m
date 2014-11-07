//
//  TestTargetTests.m
//  TestTargetTests
//
//  Created by Brian King on 11/2/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ControlsViewController.h"
#import "FRY.h"

@interface ControlsViewControllerTests : XCTestCase

@property (strong, nonatomic) ControlsViewController *viewController;

@end

@implementation ControlsViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [[ControlsViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.viewController;
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
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
    NSArray *accessibilityLabels = @[
                                     @"First",
                                     @"Second",
                                     @"Action 1",
                                     @"Action 2",
                                     @"Action 3",
                                     @"Stepper",
                                       @"Increment",
                                       @"Decrement",
                                     @"Slider",
                                     @"Switch",
                                     @"Progress",
                                     @"TI",
                                     @"T1",
                                     @"T2",
                                     @"TB",
                                     @"toolbar switch",
                                     ];
    NSMutableArray *foundViews = [NSMutableArray array];
    
    for ( NSString *accessibilityLabel in accessibilityLabels ) {
        [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]
                                          usingBlock:^(UIView *view, CGRect frameInView) {
                                              XCTAssertNotNil(view);
                                              XCTAssertEqualObjects([view accessibilityLabel], accessibilityLabel);
                                              [foundViews addObject:view];
                                          }];
    }
    
    
    XCTAssertTrue(foundViews.count == accessibilityLabels.count);
}

- (void)testTapping
{
    NSArray *accessibilityLabels = @[
//                                     @"Second",
//                                     @"First",
                                     @"Action 1",
//                                     @"Action 2",
//                                     @"Action 3",
//                                     @[@"Increment", @"Stepper"],
//                                     @[@"Decrement", @"Stepper"],
//                                     @"Switch",
//                                     @"TI",
//                                     @"T1",
//                                     @"T2",
//                                     @"TB",
//                                     @"toolbar switch",
                                     ];
    for ( id accessibilityInfo in accessibilityLabels ) {
        NSString *confirmationString = nil;
        NSString *accessibilityLabel = nil;
        if ( [accessibilityInfo isKindOfClass:[NSArray class]] ) {
            confirmationString = [accessibilityInfo lastObject];
            accessibilityLabel = [accessibilityInfo firstObject];
        }
        else {
            confirmationString = accessibilityInfo;
            accessibilityLabel = accessibilityInfo;
        }
        NSString *actionConfirmation = [NSString stringWithFormat:@"Action=%@", confirmationString];
        
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:accessibilityLabel]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
        
        
        [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:actionConfirmation]
                                          usingBlock:^(UIView *view, CGRect frameInView) {
                                              XCTAssertNotNil(view, @"%@", accessibilityLabel);
                                          }];
    }
}

- (void)testTappingDisabled
{
    NSArray *propertiesToDisable = @[
                                     @"toolbarSegmentControl",
                                     @"segmentControl",
                                     @"momentarySegmentControl",
                                     @"slider",
                                     @"stepper",
                                     @"switchControl",
                                     @"toolbarSwitchControl",
                                     @"activityIndicator",
                                     @"progressView",
                                     @"toolbarButtonItem",
                                     @"navigationButtonItem"
                                     ];
    for ( NSString *property in propertiesToDisable )
    {
        NSObject *value = [self.viewController valueForKey:property];
        [value setValue:@(NO) forKey:@"enabled"];
    }

    NSArray *accessibilityLabels = @[
                                     @"Second",
                                     @"First",
                                     @"Action 1",
                                     @"Action 2",
                                     @"Action 3",
                                     @"Stepper",
                                     @"Switch",
//                                     @"TI",
                                     @"T1",
                                     @"T2",
// This is not disabling because the UIButtonLabel is disabled, but the UIButton is enabled.
                                     @"TB",
                                     @"toolbar switch",
                                     ];
    for ( NSString *accessibilityLabel in accessibilityLabels ) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
        
        NSString *actionConfirmation = [NSString stringWithFormat:@"Action=%@", accessibilityLabel];
        
        [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:actionConfirmation]
                                          usingBlock:^(UIView *view, CGRect frameInView) {
                                              XCTAssertNil(view, @"Did not find %@", actionConfirmation);
                                          }];

        [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"No Action"]
                                          usingBlock:^(UIView *view, CGRect frameInView) {
                                              XCTAssertNotNil(view, @"Action label updated for %@", accessibilityLabel);
                                          }];
    }
}

- (void)testSlider
{
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:40
                                                      xyoffsets:0.520f,0.645f,0.000, 0.510f,0.645f,0.032, 0.500f,0.645f,0.048, 0.485f,0.645f,0.066, 0.473f,0.645f,0.083, 0.453f,0.645f,0.100, 0.429f,0.645f,0.117, 0.385f,0.645f,0.135, 0.328f,0.645f,0.151, 0.277f,0.645f,0.168, 0.255f,0.645f,0.186, 0.230f,0.645f,0.203, 0.211f,0.645f,0.220, 0.201f,0.645f,0.238, 0.194f,0.645f,0.259, 0.189f,0.645f,0.278, 0.186f,0.645f,0.298, 0.184f,0.645f,0.314, 0.172f,0.645f,0.333, 0.142f,0.645f,0.366, 0.127f,0.645f,0.384, 0.113f,0.629f,0.400, 0.103f,0.597f,0.417, 0.098f,0.548f,0.434, 0.093f,0.548f,0.450, 0.088f,0.548f,0.476, 0.086f,0.548f,0.588, 0.081f,0.548f,0.613, 0.071f,0.548f,0.640, 0.066f,0.548f,0.659, 0.056f,0.548f,0.700, 0.042f,0.516f,0.731, 0.032f,0.484f,0.761, 0.027f,0.484f,0.777, 0.025f,0.484f,0.800, 0.022f,0.484f,0.830, 0.017f,0.484f,0.848, 0.017f,0.452f,0.875, 0.015f,0.452f,0.918, 0.015f,0.452f,1.216]
             onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=1"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:63
                                                      xyoffsets:0.049f,0.452f,0.000, 0.054f,0.452f,0.136, 0.074f,0.419f,0.153, 0.088f,0.387f,0.170, 0.110f,0.387f,0.187, 0.172f,0.387f,0.223, 0.265f,0.387f,0.255, 0.326f,0.419f,0.272, 0.382f,0.484f,0.304, 0.463f,0.629f,0.331, 0.507f,0.661f,0.348, 0.539f,0.694f,0.368, 0.615f,0.742f,0.398, 0.645f,0.742f,0.414, 0.701f,0.742f,0.441, 0.718f,0.742f,0.457, 0.728f,0.774f,0.474, 0.745f,0.774f,0.491, 0.755f,0.774f,0.507, 0.770f,0.774f,0.524, 0.779f,0.774f,0.542, 0.794f,0.774f,0.559, 0.801f,0.774f,0.575, 0.806f,0.806f,0.592, 0.811f,0.806f,0.609, 0.816f,0.806f,0.630, 0.833f,0.806f,0.647, 0.855f,0.806f,0.679, 0.873f,0.806f,0.695, 0.887f,0.806f,0.712, 0.897f,0.806f,0.729, 0.907f,0.806f,0.745, 0.924f,0.806f,0.762, 0.934f,0.806f,0.779, 0.944f,0.806f,0.797, 0.949f,0.806f,0.813, 0.953f,0.806f,0.830, 0.956f,0.806f,0.851, 0.961f,0.806f,0.873, 0.966f,0.806f,0.890, 0.971f,0.806f,0.907, 0.975f,0.806f,0.924, 0.980f,0.806f,0.940, 0.985f,0.806f,0.959, 0.988f,0.806f,1.045, 0.985f,0.806f,1.203, 0.978f,0.806f,1.220, 0.973f,0.806f,1.237, 0.971f,0.806f,1.257, 0.968f,0.806f,1.290, 0.968f,0.774f,1.306, 0.963f,0.774f,1.323, 0.956f,0.742f,1.340, 0.956f,0.710f,1.359, 0.951f,0.710f,1.376, 0.951f,0.677f,1.408, 0.956f,0.677f,1.767, 0.961f,0.677f,1.833, 0.966f,0.677f,1.942, 0.968f,0.677f,1.996, 0.973f,0.677f,2.032, 0.975f,0.677f,2.184, 0.975f,0.677f,2.444]
             onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=98"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:33
                                                      xyoffsets:0.941f,0.597f,0.000, 0.934f,0.597f,0.094, 0.919f,0.597f,0.121, 0.853f,0.597f,0.147, 0.801f,0.597f,0.164, 0.750f,0.597f,0.182, 0.686f,0.597f,0.215, 0.667f,0.597f,0.232, 0.625f,0.548f,0.264, 0.610f,0.548f,0.282, 0.571f,0.548f,0.322, 0.547f,0.548f,0.350, 0.542f,0.548f,0.367, 0.534f,0.548f,0.386, 0.532f,0.548f,0.416, 0.527f,0.548f,0.448, 0.522f,0.548f,0.472, 0.517f,0.548f,0.504, 0.517f,0.581f,0.604, 0.512f,0.581f,0.692, 0.510f,0.581f,0.720, 0.505f,0.581f,0.737, 0.500f,0.581f,0.765, 0.505f,0.581f,1.170, 0.510f,0.581f,1.216, 0.515f,0.581f,1.263, 0.517f,0.581f,1.350, 0.522f,0.581f,1.382, 0.525f,0.581f,1.452, 0.520f,0.581f,1.624, 0.515f,0.581f,1.641, 0.510f,0.581f,1.670, 0.500f,0.581f,1.698]
             onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=49"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];
}

- (void)testStepper
{
    for ( NSUInteger i = 0; i < 5; i++) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Increment"]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
    }
    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=55"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];
    for ( NSUInteger i = 0; i < 5; i++) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Decrement"]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
    }
    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=50"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];
}

- (void)testActivityIndicator
{
    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"In progress"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNil(view);
                                      }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"In progress"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchInteractableAccessibilityLabel:@"Switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_enumerateDepthFirstViewMatching:[NSPredicate fry_matchAccessibilityLabel:@"In progress"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNil(view);
                                      }];
}

@end
