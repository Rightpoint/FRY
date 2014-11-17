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
#define TableViewDeleteConfirmTitleForRow(i) [[UIDevice currentDevice].systemVersion intValue] == 8 ? @"Delete" : [NSString stringWithFormat:@"Delete, Item %zd", i]

#define ROW_COUNT 2

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

// Enable this to aide in lookup failures.
//    [NSObject fry_enableLookupDebugForObjects:@[self.viewController.tableView]];
//    [FRYDSLResult setPauseForeverOnFailure:YES];
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
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY_KEY.accessibilityLabel(@"Add").depthFirst().tap();
    }
}

- (void)testPopulation
{
    [self populateTable];
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY_KEY.accessibilityLabel(TableViewTitleForRow(i)).depthFirst().present();
    }
}

- (void)testSelectedState
{
    [self populateTable];
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.accessibilityLabel(TableViewTitleForRow(i)).depthFirst().tap();
        FRY.accessibilityLabel(TableViewTitleForRow(i)).accessibilityTraits(UIAccessibilityTraitSelected).all().present();
    }
}

- (void)testSelectedStateByIndexPath
{
    [self populateTable];
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.atIndexPath([NSIndexPath indexPathForRow:i inSection:0]).depthFirst().tap();
        FRY.accessibilityLabel(TableViewTitleForRow(i)).accessibilityTraits(UIAccessibilityTraitSelected).all().present();
    }
}

- (void)testEditLabels
{
    [self populateTable];
    FRY_KEY.accessibilityLabel(@"Edit").depthFirst().tap();

    for ( NSUInteger i = 1; i < ROW_COUNT; i++ ) {
        FRY_KEY.accessibilityLabel(TableViewReorderTitleForRow(i)).all().present();
        FRY_KEY.accessibilityLabel(TableViewDeleteTitleForRow(i)).all().present();
    }
}

- (void)testDeleteTap
{
    [self populateTable];
    FRY_KEY.accessibilityLabel(@"Edit").depthFirst().tap();

    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY_KEY.accessibilityLabel(TableViewDeleteTitleForRow(i)).depthFirst().tap();
        FRY_KEY.accessibilityLabel(TableViewDeleteConfirmTitleForRow(i)).depthFirst().tap();
    }
}

- (void)testDeleteSwipe
{
    [self populateTable];

    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY_KEY.accessibilityLabel(TableViewTitleForRow(i)).depthFirst().touch([FRYTouch swipeInDirection:FRYDirectionLeft]);
        FRY_KEY.accessibilityLabel(TableViewDeleteConfirmTitleForRow(i)).depthFirst().tap();
    }
}

- (void)testReorder
{
    [self populateTable];
    FRY_KEY.accessibilityLabel(@"Edit").depthFirst().tap();
    
    UIView *reorderKnobView = FRY_KEY.accessibilityLabel(TableViewReorderTitleForRow(0)).depthFirst().present().view;

    // Drag the view down 4 rows
    CGRect originalLocation = [FRY_KEY_WINDOW convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    [reorderKnobView fry_simulateTouch:[FRYTouch pressAndDragFromPoint:CGPointMake(0.5, 0.5)
                                                                        toPoint:CGPointMake(0.5, 4.5)
                                                                    forDuration:1]];
    
    reorderKnobView = FRY_KEY.accessibilityLabel(TableViewReorderTitleForRow(0)).depthFirst().present().view;

    CGRect newLocation = [FRY_KEY_WINDOW convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    
    XCTAssertFalse(CGRectEqualToRect(originalLocation, newLocation));
}

- (void)testScrolling
{
    self.viewController.tableView.rowHeight = 180.0f;
    [self.viewController.tableView reloadData];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    for ( NSUInteger i = 0; i < 10; i++ ) {
        FRY_KEY.accessibilityLabel(@"Add").depthFirst().tap();
    }
    // This is not a good test of fry_searchForViewsMatching:lookInDirection: as UITableView returns accessibility elements for the entire data set, visible
    // or not.   But lets ensure that it works anyway, because I don't have any other tests.
    XCTAssert([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchAccessibilityLabel:@"Item 9"] lookInDirection:FRYDirectionDown]);
    XCTAssert([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchAccessibilityLabel:@"Item 9"] lookInDirection:FRYDirectionDown]);
    XCTAssert([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchAccessibilityLabel:@"Item 0"] lookInDirection:FRYDirectionDown]);
    XCTAssert([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchAccessibilityLabel:@"Item 9"] lookInDirection:FRYDirectionDown]);
    
}

- (void)testScrollingByIndexPath
{
    self.viewController.tableView.rowHeight = 180.0f;
    [self.viewController.tableView reloadData];
    [[NSRunLoop currentRunLoop] fry_waitForIdle];
    for ( NSUInteger i = 0; i < 10; i++ ) {
        FRY_KEY.accessibilityLabel(@"Add").depthFirst().tap();
    }
    // This is a better test, as the containerIndexPath is not returned by accessibilityElements.
    XCTAssert([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchContainerIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]] lookInDirection:FRYDirectionDown]);
    // Looking down should not work.
    XCTAssertFalse([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchContainerIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] lookInDirection:FRYDirectionDown]);
    XCTAssert([self.viewController.tableView fry_searchForViewsMatching:[NSPredicate fry_matchContainerIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] lookInDirection:FRYDirectionUp]);
}

@end
