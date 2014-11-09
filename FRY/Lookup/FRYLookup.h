//
//  FRYLookup.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYDefines.h"

/**
 * This protocol will add support for performing an NSPredicate search over an arbitrary tree structure.
 */
@protocol FRYLookup <NSObject>

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
- (CGRect)fry_frameInView;

/**
 * A depth first traversal, similar to hitTest:event:, to return the deepest object in the tree matching the
 * predicate.   The block is always triggered before the method is returned.  If nothing is found, view will be nil.
 * This allows us to hide FRYLookup from API clients.
 */
- (void)fry_farthestDescendentMatching:(NSPredicate *)predicate usingBlock:(FRYMatchBlock)block;

- (id<FRYLookup>)fry_farthestDescendentMatching:(NSPredicate *)predicate;

/**
 * Enumerate the entire tree for objects matching predicate, and trigger the FRYMatchBlock
 */
- (void)fry_enumerateAllChildrenMatching:(NSPredicate *)predicate usingBlock:(FRYMatchBlock)block;

@end
