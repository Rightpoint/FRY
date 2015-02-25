//
//  UIView+FRYLookup.h
//  FRYolator
//
//  Created by Brian King on 2/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FRYLookup)

/**
 *  Return a dictionary that identifies the current view.   This is used
 *  by the touch recorder to help re-create touches in a more durable manner.
 */
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

@end
