//
//  TableViewControllerTests.m
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRY.h"
#import "TableViewController.h"

#define TableViewReorderTitleForRow(i) [NSString stringWithFormat:@"Reorder Item %zd", i]
#define TableViewDeleteTitleForRow(i) [NSString stringWithFormat:@"Delete Item %zd", i]
#define TableViewDeleteConfirmTitleForRow(i) [NSString stringWithFormat:@"Delete, Item %zd", i]

@interface TableViewControllerTests : XCTestCase

@property (strong, nonatomic) TableViewController *viewController;

@end

@implementation TableViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [[TableViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:450000]];
}

- (void)tearDown {
    if ([[FRYTouchDispatch shared] hasActiveTouches]) {
        [[FRYTouchDispatch shared] clearInteractionsAndTouches];
        XCTAssertFalse(YES);
    }
    
    [super tearDown];
}

- (void)populateTable
{
    for ( NSUInteger i = 0; i < 5; i++ ) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Add"]];
    }
}

- (void)testPopulation
{
    [self populateTable];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewTitleForRow(i)]
                                     usingBlock:^(UIView *view, CGRect frameInView) {
                                         XCTAssertNotNil(view, @"");
                                     }];
    }
}

- (void)testSelectedState
{
    [self populateTable];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewTitleForRow(i)]];
        
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewTitleForRow(i) accessibilityTrait:UIAccessibilityTraitSelected]
                                     usingBlock:^(UIView *view, CGRect frameInView) {
                                         XCTAssertNotNil(view, @"");
                                     }];
    }
}

- (void)testEditLabels
{
    [self populateTable];
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Edit"]];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewReorderTitleForRow(i)]
                                     usingBlock:^(UIView *view, CGRect frameInView) {
                                         XCTAssertNotNil(view, @"");
                                     }];
        [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewDeleteTitleForRow(i)]
                                     usingBlock:^(UIView *view, CGRect frameInView) {
                                         XCTAssertNotNil(view, @"");
                                     }];
    }
}

- (void)testDeleteTap
{
    [self populateTable];
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Edit"]];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewDeleteTitleForRow(i)]];
        
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewDeleteConfirmTitleForRow(i)]];
    }
}

- (void)testDeleteSwipe
{
    [self populateTable];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch swipeInDirection:FRYTouchDirectionLeft]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewTitleForRow(i)]];
        
        [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
                 onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewDeleteConfirmTitleForRow(i)]];
    }
}

- (void)testReorder
{
    [self populateTable];
    [FRY_KEY fry_simulateTouch:[FRYSyntheticTouch tap]
             onSubviewMatching:[NSPredicate fry_matchAccessibilityLabel:@"Edit"]];
    
    __block UIView *reorderKnobView = nil;
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewReorderTitleForRow(0)]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                     XCTAssertNotNil(view, @"");
                                     reorderKnobView = view;
                                 }];
    // Drag the view down 4 rows
    CGRect originalLocation = [FRY_KEY convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    [reorderKnobView fry_simulateTouch:[FRYSyntheticTouch pressAndDragFromPoint:CGPointMake(0.5, 0.5)
                                                                        toPoint:CGPointMake(0.5, 4.5)
                                                                    forDuration:1]];
    
    [FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:TableViewReorderTitleForRow(0)]
                                 usingBlock:^(UIView *view, CGRect frameInView) {
                                     XCTAssertNotNil(view, @"");
                                     reorderKnobView = view;
                                 }];
    CGRect newLocation = [FRY_KEY convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    
    XCTAssertFalse(CGRectEqualToRect(originalLocation, newLocation));
}

@end
