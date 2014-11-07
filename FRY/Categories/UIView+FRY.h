//
//  UIView+FRY.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYSimulatedTouch.h"

@interface UIView (FRY)

- (UIView *)fry_animatingViewToWaitFor;

- (NSArray *)fry_reverseSubviews;

- (NSDictionary *)fry_matchingLookupVariables;

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
- (void)fry_simulateTouch:(FRYSimulatedTouch *)touch insideRect:(CGRect)frameInView;
- (void)fry_simulateTouch:(FRYSimulatedTouch *)touch;

- (void)fry_simulateTouch:(FRYSimulatedTouch *)touch onSubviewMatching:(NSPredicate *)predicate;
- (void)fry_simulateTouches:(NSArray *)touches onSubviewMatching:(NSPredicate *)predicate;

@end
