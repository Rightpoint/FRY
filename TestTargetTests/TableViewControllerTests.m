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
        FRYD_KEY.accessibilityLabel(@"Add").depthFirst().tap();
    }
}

- (void)testPopulation
{
    [self populateTable];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        FRYD_KEY.accessibilityLabel(TableViewTitleForRow(i)).depthFirst().present();
    }
}

- (void)testSelectedState
{
    [self populateTable];
    for ( NSUInteger i = 0; i < 5; i++ ) {
        FRYD_KEY.accessibilityLabel(TableViewTitleForRow(i)).depthFirst().tap();
        FRYD_KEY.accessibilityLabel(TableViewTitleForRow(i)).accessibilityTraits(UIAccessibilityTraitSelected).all().present();
    }
}

- (void)testEditLabels
{
    [self populateTable];
    FRYD_KEY.accessibilityLabel(@"Edit").depthFirst().tap();

    for ( NSUInteger i = 0; i < 5; i++ ) {
        FRYD_KEY.accessibilityLabel(TableViewReorderTitleForRow(i)).depthFirst().present();
        FRYD_KEY.accessibilityLabel(TableViewDeleteTitleForRow(i)).depthFirst().present();
    }
}

- (void)testDeleteTap
{
    [self populateTable];
    FRYD_KEY.accessibilityLabel(@"Edit").depthFirst().tap();

    for ( NSUInteger i = 0; i < 5; i++ ) {
        FRYD_KEY.accessibilityLabel(TableViewDeleteTitleForRow(i)).depthFirst().tap();
        FRYD_KEY.accessibilityLabel(TableViewDeleteConfirmTitleForRow(i)).depthFirst().tap();
    }
}

- (void)testDeleteSwipe
{
    [self populateTable];

    for ( NSUInteger i = 0; i < 5; i++ ) {
        FRYD_KEY.accessibilityLabel(TableViewTitleForRow(i)).depthFirst().touch([FRYTouch swipeInDirection:FRYTouchDirectionLeft]);
        FRYD_KEY.accessibilityLabel(TableViewDeleteConfirmTitleForRow(i)).depthFirst().tap();
    }
}

- (void)testReorder
{
    [self populateTable];
    FRYD_KEY.accessibilityLabel(@"Edit").depthFirst().tap();
    
    UIView *reorderKnobView = FRYD_KEY.accessibilityLabel(TableViewReorderTitleForRow(0)).depthFirst().present().view;

    // Drag the view down 4 rows
    CGRect originalLocation = [FRY_KEY convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    [reorderKnobView fry_simulateTouch:[FRYTouch pressAndDragFromPoint:CGPointMake(0.5, 0.5)
                                                                        toPoint:CGPointMake(0.5, 4.5)
                                                                    forDuration:1]];
    
    reorderKnobView = FRYD_KEY.accessibilityLabel(TableViewReorderTitleForRow(0)).depthFirst().present().view;

    CGRect newLocation = [FRY_KEY convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    
    XCTAssertFalse(CGRectEqualToRect(originalLocation, newLocation));
}

@end
