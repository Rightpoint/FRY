//
//  TableViewControllerTests.m
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FRY/FRY.h>

#import "TableViewController.h"

#define TableViewReorderTitleForRow(i) [NSString stringWithFormat:@"Reorder Item %zd", i]
#define TableViewDeleteTitleForRow(i) [NSString stringWithFormat:@"Delete Item %zd", i]
#define TableViewDeleteConfirmTitleForRow(i) [[UIDevice currentDevice].systemVersion intValue] == 8 ? @"Delete" : [NSString stringWithFormat:@"Delete, Item %zd", i]

#define ROW_COUNT 2

@interface TableViewControllerTests : XCTestCase

@property (strong, nonatomic) TableViewController *viewController;

@end

@implementation TableViewControllerTests

- (void)setUp
{
    [super setUp];
    self.viewController = [[TableViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];

// Enable this to aide in lookup failures.
//    [NSObject fry_enableLookupDebugForObjects:@[self.viewController.tableView]];
}

- (void)populateTable
{
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(@"Add").tap();
    }
}

- (void)testPopulation
{
    [self populateTable];
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(TableViewTitleForRow(i)).present();
    }
}

- (void)testSelectedState
{
    [self populateTable];
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(TableViewTitleForRow(i)).tap();
        FRY.lookup(@[FRY_accessibilityLabel(TableViewTitleForRow(i)),
                      FRY_accessibilityTrait(UIAccessibilityTraitSelected)]).present();
    }
}

- (void)testSelectedStateByIndexPath
{

    [self populateTable];
    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.lookupFirst(FRY_atSectionAndRow(0, i)).tap();
        FRY.lookup(@[FRY_accessibilityLabel(TableViewTitleForRow(i)),
                      FRY_accessibilityTrait(UIAccessibilityTraitSelected)]).present();
    }
}

- (void)testEditLabels
{
    [self populateTable];
    FRY.lookupFirstByAccessibilityLabel(@"Edit").tap();

    for ( NSUInteger i = 1; i < ROW_COUNT; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(TableViewReorderTitleForRow(i)).present();
        FRY.lookupFirstByAccessibilityLabel(TableViewDeleteTitleForRow(i)).present();
    }
}

- (void)testDeleteTap
{
    [self populateTable];
    FRY.lookupFirstByAccessibilityLabel(@"Edit").tap();

    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(TableViewDeleteTitleForRow(i)).tap();
        FRY.lookupFirstByAccessibilityLabel(TableViewDeleteConfirmTitleForRow(i)).tap();
    }
}

- (void)testDeleteSwipe
{
    [self populateTable];

    for ( NSUInteger i = 0; i < ROW_COUNT; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(TableViewTitleForRow(i)).touch([FRYTouch swipeInDirection:FRYDirectionLeft]);
        FRY.lookupFirstByAccessibilityLabel(TableViewDeleteConfirmTitleForRow(i)).tap();
    }
}

- (void)testReorder
{
    [self populateTable];
    FRY.lookupFirstByAccessibilityLabel(@"Edit").tap();

    FRY.lookupFirstByAccessibilityLabel(TableViewReorderTitleForRow(0)).present();
    UIView *reorderKnobView = FRY.lookupFirstByAccessibilityLabel(TableViewReorderTitleForRow(0)).view;

    // Drag the view down 4 rows
    CGRect originalLocation = [FRY_KEY_WINDOW convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    FRYTouch *t = [FRYTouch pressAndDragFromPoint:CGPointMake(0.5, 0.5)
                                          toPoint:CGPointMake(0.5, 4.5)
                                      forDuration:1];
    [[FRYTouchDispatch shared] simulateTouches:@[t]
                                        inView:reorderKnobView];

    FRY.lookupFirstByAccessibilityLabel(TableViewReorderTitleForRow(0)).present();

    reorderKnobView = FRY.lookupFirstByAccessibilityLabel(TableViewReorderTitleForRow(0)).view;

    CGRect newLocation = [FRY_KEY_WINDOW convertRect:reorderKnobView.bounds fromView:reorderKnobView];
    
    XCTAssertFalse(CGRectEqualToRect(originalLocation, newLocation));
}

- (void)testScrolling
{
    self.viewController.tableView.rowHeight = 180.0f;
    [self.viewController.tableView reloadData];
    [[FRYIdleCheck system] waitForIdle];
    for ( NSUInteger i = 0; i < 10; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(@"Add").tap();
    }
    // This is not a good test of fry_searchForViewsMatching:lookInDirection: as UITableView returns accessibility elements for the entire data set, visible
    // or not.   But lets ensure that it works anyway, because I don't have any other tests.
    XCTAssertTrue(FRY.scrollTo(FRY_accessibilityLabel(@"Item 9")));
    XCTAssertTrue(FRY.scrollTo(FRY_accessibilityLabel(@"Item 9")));
    XCTAssertTrue(FRY.scrollTo(FRY_accessibilityLabel(@"Item 0")));
    XCTAssertTrue(FRY.scrollTo(FRY_accessibilityLabel(@"Item 9")));
}

- (void)testScrollingByIndexPath
{
    self.viewController.tableView.rowHeight = 180.0f;
    [self.viewController.tableView reloadData];
    [[FRYIdleCheck system] waitForIdle];
    for ( NSUInteger i = 0; i < 10; i++ ) {
        FRY.lookupFirstByAccessibilityLabel(@"Add").tap();
    }

    // This is a better test, as the containerIndexPath is not returned by accessibilityElements.
    XCTAssertTrue(FRY.searchFor(FRYDirectionDown, FRY_atSectionAndRow(0, 9)));
    // Looking down should not work.
    XCTAssertFalse(FRY.searchFor(FRYDirectionDown, FRY_atSectionAndRow(0, 0)));
    XCTAssertTrue(FRY.searchFor(FRYDirectionUp, FRY_atSectionAndRow(0, 0)));
}

@end
