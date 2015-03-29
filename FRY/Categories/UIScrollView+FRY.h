//
//  UIScrollView+FRY.h
//  FRY
//
//  Created by Brian King on 11/16/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYDefines.h"

@interface UIScrollView(FRY)

/**
 *  Search the hierarchy for a result matching predicate, and if there is no match, scroll in the direction and search again.
 *  Keep scrolling in the specified direction until a result is found, or the scroll view runs out of space to scroll.
 */
- (BOOL)fry_searchForViewsMatching:(NSPredicate *)predicate lookInDirection:(FRYDirection)direction;

/**
 *  Scroll to the result of the depth-first search matching the predicate.  This will only work for
 *  UIScrollView subclasses that return UIAccessibilityElements out side of the visible bounds.  To be 
 *  clear, this will not scroll and search like fry_searchForViewsMatching:lookInDirection:.
 */
- (BOOL)fry_scrollToLookupResultMatching:(NSPredicate *)predicate;

@end
