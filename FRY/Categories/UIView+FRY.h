//
//  UIView+FRY.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYTouch.h"

@interface UIView (FRY)

/**
 *  Check to see if the view has any active CAAnimation objects.
 */
- (BOOL)fry_isAnimating;

- (UIView *)fry_animatingViewToWaitFor;

/**
 *  Find the superview that has more interactability than this view.
 *  This is not needed for any reason, but often chooses a view that is
 *  more interesting in case of tapping private subviews.
 */
- (UIView *)fry_interactableParent;

/**
 *  Return all subviews in reverse order.
 */
- (NSArray *)fry_reverseSubviews;

/**
 *  Return a dictionary that identifies the current view.   This is used
 *  by the touch recorder to help re-create touches in a more durable manner.
 */
- (NSDictionary *)fry_matchingLookupVariables;

/**
 *  If the view is a cell in a containerview, this will return the index path for this view.
 *  It works with UITableViewCells and UICollectionViewCells.
 */
- (NSIndexPath *)fry_indexPathInContainer;

/**
 * This method returns the view that is lookup-able at a given point.  hitTest will often return
 * a containing UIView and handle the hit testing internally, but that UIView will not be able to be
 * looked up via accessibility label.   This will return a more specific view to focus the touch on that
 * we will be able to lookup at a later time.
 *
 * UINavigationBar for instance is always the hitTest:event: target, even though it is not lookup-able.
 */
- (UIView *)fry_lookupMatchingViewAtPoint:(CGPoint)point;


- (void)fry_simulateTouches:(NSArray *)touches insideRect:(CGRect)frameInView;
- (void)fry_simulateTouches:(NSArray *)touches;
- (void)fry_simulateTouch:(FRYTouch *)touch insideRect:(CGRect)frameInView;
- (void)fry_simulateTouch:(FRYTouch *)touch;

- (void)fry_simulateTouch:(FRYTouch *)touch onSubviewMatching:(NSPredicate *)predicate;
- (void)fry_simulateTouches:(NSArray *)touches onSubviewMatching:(NSPredicate *)predicate;

@end
