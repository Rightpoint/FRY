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
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]
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
                                     @"Second",
                                     @"First",
                                     @"Action 1",
                                     @"Action 2",
                                     @"Action 3",
                                     @[@"Increment", @"Stepper"],
                                     @[@"Decrement", @"Stepper"],
                                     @"Switch",
                                     @"toolbar switch",
                                     @"TI",
                                     @"T1",
                                     @"T2",
                                     @"TB",
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
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
        
        
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:actionConfirmation]
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
                                     @"toolbarButton"
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
                                     @"TI",
                                     @"T1",
                                     @"T2",
                                     @"TB",
                                     @"toolbar switch",
                                     ];
    for ( NSString *accessibilityLabel in accessibilityLabels ) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
        
        NSString *actionConfirmation = [NSString stringWithFormat:@"Action=%@", accessibilityLabel];
        
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:actionConfirmation]
                                     usingBlock:^(UIView *view, CGRect frameInView) {
                                         XCTAssertNil(view, @"Did not find %@", actionConfirmation);
                                     }];

        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"No Action"]
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
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=0"]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                     XCTAssertNotNil(view);
                                 }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:63
                                                      xyoffsets:0.049f,0.452f,0.000, 0.054f,0.452f,0.136, 0.074f,0.419f,0.153, 0.088f,0.387f,0.170, 0.110f,0.387f,0.187, 0.172f,0.387f,0.223, 0.265f,0.387f,0.255, 0.326f,0.419f,0.272, 0.382f,0.484f,0.304, 0.463f,0.629f,0.331, 0.507f,0.661f,0.348, 0.539f,0.694f,0.368, 0.615f,0.742f,0.398, 0.645f,0.742f,0.414, 0.701f,0.742f,0.441, 0.718f,0.742f,0.457, 0.728f,0.774f,0.474, 0.745f,0.774f,0.491, 0.755f,0.774f,0.507, 0.770f,0.774f,0.524, 0.779f,0.774f,0.542, 0.794f,0.774f,0.559, 0.801f,0.774f,0.575, 0.806f,0.806f,0.592, 0.811f,0.806f,0.609, 0.816f,0.806f,0.630, 0.833f,0.806f,0.647, 0.855f,0.806f,0.679, 0.873f,0.806f,0.695, 0.887f,0.806f,0.712, 0.897f,0.806f,0.729, 0.907f,0.806f,0.745, 0.924f,0.806f,0.762, 0.934f,0.806f,0.779, 0.944f,0.806f,0.797, 0.949f,0.806f,0.813, 0.953f,0.806f,0.830, 0.956f,0.806f,0.851, 0.961f,0.806f,0.873, 0.966f,0.806f,0.890, 0.971f,0.806f,0.907, 0.975f,0.806f,0.924, 0.980f,0.806f,0.940, 0.985f,0.806f,0.959, 0.988f,0.806f,1.045, 0.985f,0.806f,1.203, 0.978f,0.806f,1.220, 0.973f,0.806f,1.237, 0.971f,0.806f,1.257, 0.968f,0.806f,1.290, 0.968f,0.774f,1.306, 0.963f,0.774f,1.323, 0.956f,0.742f,1.340, 0.956f,0.710f,1.359, 0.951f,0.710f,1.376, 0.951f,0.677f,1.408, 0.956f,0.677f,1.767, 0.961f,0.677f,1.833, 0.966f,0.677f,1.942, 0.968f,0.677f,1.996, 0.973f,0.677f,2.032, 0.975f,0.677f,2.184, 0.975f,0.677f,2.444]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=100"]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                     XCTAssertNotNil(view);
                                 }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:33
                                                      xyoffsets:0.941f,0.597f,0.000, 0.934f,0.597f,0.094, 0.919f,0.597f,0.121, 0.853f,0.597f,0.147, 0.801f,0.597f,0.164, 0.750f,0.597f,0.182, 0.686f,0.597f,0.215, 0.667f,0.597f,0.232, 0.625f,0.548f,0.264, 0.610f,0.548f,0.282, 0.571f,0.548f,0.322, 0.547f,0.548f,0.350, 0.542f,0.548f,0.367, 0.534f,0.548f,0.386, 0.532f,0.548f,0.416, 0.527f,0.548f,0.448, 0.522f,0.548f,0.472, 0.517f,0.548f,0.504, 0.517f,0.581f,0.604, 0.512f,0.581f,0.692, 0.510f,0.581f,0.720, 0.505f,0.581f,0.737, 0.500f,0.581f,0.765, 0.505f,0.581f,1.170, 0.510f,0.581f,1.216, 0.515f,0.581f,1.263, 0.517f,0.581f,1.350, 0.522f,0.581f,1.382, 0.525f,0.581f,1.452, 0.520f,0.581f,1.624, 0.515f,0.581f,1.641, 0.510f,0.581f,1.670, 0.500f,0.581f,1.698]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=50"]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];
}

- (void)testStepper
{
    for ( NSUInteger i = 0; i < 5; i++) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Increment"]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
    }
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=75"]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                     XCTAssertNotNil(view);
                                 }];
    for ( NSUInteger i = 0; i < 5; i++) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Decrement"]];
        [[NSRunLoop currentRunLoop] fry_waitForIdle];
    }
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Slider=50"]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                     XCTAssertNotNil(view);
                                 }];
}

- (void)testActivityIndicator
{
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"In progress"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNil(view);
                                      }];

    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"In progress"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNotNil(view);
                                      }];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];

    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"In progress"]
                                      usingBlock:^(UIView *view, CGRect frameInView) {
                                          XCTAssertNil(view);
                                      }];
}


- (void)testFoo
{
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.793f,0.586f,0.000, 0.793f,0.586f,0.120]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Second"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.301f,0.552f,0.000, 0.301f,0.552f,0.074]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"First"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.638f,0.379f,0.000, 0.638f,0.379f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Second"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.228f,0.379f,0.000, 0.228f,0.379f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"First"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.221f,0.759f,0.000, 0.221f,0.759f,0.079]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 1"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.477f,0.672f,0.000, 0.477f,0.672f,0.064]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 2"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.893f,0.569f,0.000, 0.893f,0.569f,0.072]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 3"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.505f,0.879f,0.000, 0.505f,0.879f,0.097]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 2"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.784f,0.879f,0.000, 0.784f,0.879f,0.128]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 3"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.571f,0.828f,0.000, 0.571f,0.828f,0.072]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 2"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.812f,0.759f,0.000, 0.812f,0.759f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Action 3"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.382f,0.565f,0.000, 0.382f,0.565f,0.063]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@ ", @"fry_accessibilityLabel", @"Switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.451f,0.613f,0.000, 0.451f,0.613f,0.073]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@ ", @"fry_accessibilityLabel", @"Switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:46
                                                      xyoffsets:0.504f,0.645f,0.000, 0.507f,0.645f,0.106, 0.523f,0.645f,0.123, 0.540f,0.645f,0.140, 0.555f,0.645f,0.157, 0.567f,0.645f,0.175, 0.585f,0.645f,0.192, 0.606f,0.645f,0.209, 0.629f,0.645f,0.229, 0.643f,0.645f,0.246, 0.658f,0.645f,0.265, 0.673f,0.645f,0.296, 0.669f,0.645f,0.354, 0.646f,0.645f,0.371, 0.606f,0.613f,0.388, 0.551f,0.548f,0.405, 0.507f,0.452f,0.423, 0.445f,0.371f,0.440, 0.398f,0.339f,0.457, 0.370f,0.323f,0.475, 0.349f,0.323f,0.492, 0.335f,0.323f,0.509, 0.326f,0.323f,0.527, 0.319f,0.323f,0.543, 0.315f,0.323f,0.562, 0.312f,0.323f,0.579, 0.319f,0.323f,0.620, 0.352f,0.323f,0.637, 0.417f,0.226f,0.655, 0.491f,0.161f,0.672, 0.549f,0.081f,0.689, 0.623f,0.048f,0.706, 0.660f,0.016f,0.723, 0.681f,0.016f,0.741, 0.690f,0.016f,0.758, 0.685f,0.016f,0.812, 0.671f,0.016f,0.829, 0.644f,0.048f,0.846, 0.611f,0.081f,0.863, 0.574f,0.113f,0.880, 0.546f,0.194f,0.897, 0.519f,0.226f,0.915, 0.502f,0.226f,0.932, 0.491f,0.242f,0.949, 0.484f,0.242f,0.966, 0.484f,0.242f,1.013]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:36
                                                      xyoffsets:0.500f,0.565f,0.000, 0.504f,0.565f,0.032, 0.514f,0.565f,0.049, 0.537f,0.565f,0.066, 0.565f,0.565f,0.083, 0.618f,0.565f,0.101, 0.658f,0.565f,0.118, 0.710f,0.565f,0.137, 0.746f,0.565f,0.154, 0.798f,0.565f,0.188, 0.805f,0.565f,0.204, 0.808f,0.565f,0.221, 0.812f,0.565f,0.238, 0.808f,0.565f,0.296, 0.785f,0.565f,0.313, 0.741f,0.597f,0.330, 0.706f,0.629f,0.347, 0.683f,0.661f,0.364, 0.662f,0.661f,0.382, 0.653f,0.661f,0.400, 0.657f,0.661f,0.442, 0.674f,0.661f,0.459, 0.711f,0.597f,0.476, 0.752f,0.565f,0.494, 0.792f,0.565f,0.511, 0.810f,0.565f,0.540, 0.833f,0.565f,0.563, 0.842f,0.565f,0.580, 0.845f,0.532f,0.598, 0.856f,0.452f,0.615, 0.866f,0.419f,0.632, 0.877f,0.387f,0.649, 0.887f,0.387f,0.667, 0.891f,0.387f,0.684, 0.891f,0.355f,0.705, 0.891f,0.355f,0.802]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@ ", @"fry_accessibilityLabel", @"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:44
                                                      xyoffsets:0.861f,0.516f,0.000, 0.857f,0.516f,0.050, 0.845f,0.516f,0.066, 0.827f,0.516f,0.083, 0.787f,0.516f,0.100, 0.736f,0.516f,0.117, 0.662f,0.516f,0.134, 0.574f,0.516f,0.152, 0.489f,0.516f,0.169, 0.431f,0.516f,0.187, 0.364f,0.484f,0.205, 0.289f,0.452f,0.222, 0.225f,0.452f,0.242, 0.160f,0.484f,0.273, 0.134f,0.516f,0.290, 0.125f,0.516f,0.306, 0.125f,0.484f,0.323, 0.125f,0.419f,0.340, 0.125f,0.403f,0.362, 0.129f,0.403f,0.386, 0.143f,0.403f,0.403, 0.176f,0.403f,0.420, 0.217f,0.403f,0.438, 0.261f,0.435f,0.455, 0.285f,0.468f,0.473, 0.312f,0.500f,0.490, 0.319f,0.565f,0.506, 0.326f,0.597f,0.523, 0.319f,0.597f,0.588, 0.305f,0.597f,0.606, 0.275f,0.597f,0.623, 0.254f,0.597f,0.639, 0.234f,0.597f,0.656, 0.224f,0.597f,0.673, 0.220f,0.597f,0.690, 0.217f,0.597f,0.707, 0.213f,0.597f,0.724, 0.208f,0.629f,0.740, 0.201f,0.629f,0.757, 0.197f,0.629f,0.774, 0.194f,0.629f,0.792, 0.194f,0.597f,0.916, 0.194f,0.565f,0.942, 0.194f,0.565f,1.007]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:56
                                                      xyoffsets:0.194f,0.532f,0.000, 0.204f,0.532f,0.023, 0.222f,0.532f,0.041, 0.266f,0.532f,0.059, 0.333f,0.532f,0.076, 0.417f,0.532f,0.093, 0.461f,0.532f,0.111, 0.496f,0.532f,0.127, 0.546f,0.532f,0.145, 0.577f,0.532f,0.162, 0.625f,0.532f,0.178, 0.690f,0.532f,0.198, 0.745f,0.532f,0.214, 0.778f,0.565f,0.234, 0.813f,0.597f,0.265, 0.799f,0.597f,0.290, 0.741f,0.532f,0.307, 0.687f,0.468f,0.324, 0.576f,0.371f,0.342, 0.467f,0.339f,0.359, 0.338f,0.339f,0.376, 0.264f,0.339f,0.393, 0.218f,0.339f,0.411, 0.192f,0.339f,0.429, 0.185f,0.339f,0.447, 0.190f,0.339f,0.497, 0.211f,0.371f,0.515, 0.248f,0.371f,0.532, 0.292f,0.306f,0.549, 0.343f,0.129f,0.566, 0.407f,-0.065f,0.583, 0.458f,-0.129f,0.601, 0.509f,-0.177f,0.618, 0.535f,-0.177f,0.635, 0.555f,-0.177f,0.652, 0.558f,-0.210f,0.670, 0.562f,-0.210f,0.687, 0.565f,-0.210f,0.705, 0.565f,-0.242f,0.723, 0.562f,-0.242f,0.756, 0.521f,-0.177f,0.774, 0.463f,-0.032f,0.791, 0.412f,0.097f,0.808, 0.349f,0.226f,0.825, 0.319f,0.306f,0.842, 0.298f,0.339f,0.859, 0.292f,0.355f,0.877, 0.303f,0.355f,0.916, 0.347f,0.355f,0.933, 0.398f,0.355f,0.950, 0.452f,0.355f,0.967, 0.475f,0.355f,0.984, 0.496f,0.355f,1.001, 0.504f,0.355f,1.019, 0.507f,0.355f,1.036, 0.507f,0.355f,1.126]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@ ", @"fry_accessibilityLabel", @"Slider"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.120]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.072]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.064]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.088]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.803f,0.534f,0.000, 0.803f,0.534f,0.129]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.094]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.064]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.064]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.088]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.261f,0.259f,0.000, 0.261f,0.259f,0.112]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"Stepper"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.227f,0.645f,0.000, 0.227f,0.645f,0.104]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"T1"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.765f,0.774f,0.000, 0.765f,0.774f,0.074]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"T2"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.371f,0.790f,0.000, 0.371f,0.790f,0.080]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"T1"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.533f,0.602f,0.000, 0.533f,0.602f,0.096]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"TI"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.569f,0.548f,0.000, 0.569f,0.548f,0.086]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@ && %K = %@", @"fry_accessibilityValue", @"0", @"fry_accessibilityLabel", @"toolbar switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.569f,0.548f,0.000, 0.569f,0.548f,0.087]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@ && %K = %@", @"fry_accessibilityValue", @"1", @"fry_accessibilityLabel", @"toolbar switch"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch touchStarting:0.000
                                                         points:2
                                                      xyoffsets:0.409f,0.470f,0.000, 0.409f,0.470f,0.054]
             onSubviewMatching:[NSPredicate predicateWithFormat:@"%K = %@", @"fry_accessibilityLabel", @"TB"]];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
}

@end
