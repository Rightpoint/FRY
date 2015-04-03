//
//  FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 11/13/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This protocol defines all of the methods required to support
 * lookup in FRY.
 */
@protocol FRYLookupSupport <NSObject>
@optional
/**
 * The keypaths that should be traversed.
 */
+ (NSSet *)fry_childKeyPaths;

/**
 * The view object that contains this object
 */
- (UIView *)fry_representingView;

/**
 * The location inside the frame where this object exists.
 */
- (CGRect)fry_frameInWindow;

/**
 *  Check to see if the view has any active CAAnimation objects.
 */
- (BOOL)fry_isAnimating;

/**
 * Check to see if the view is inside of the window bounds, and should be visible to the user
 */
- (BOOL)fry_isOnScreen;

@end
