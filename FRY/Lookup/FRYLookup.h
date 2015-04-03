//
//  FRYLookup.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookupSupport.h"

/**
 * This protocol will add support for performing an NSPredicate search over an arbitrary tree structure.
 */
@protocol FRYLookup <FRYLookupSupport>

@optional
/**
 * A depth first traversal, similar to hitTest:event:, to return the deepest object in the tree matching the
 * predicate.
 */
- (id<FRYLookup>)fry_farthestDescendentMatching:(NSPredicate *)predicate;

/**
 *  A shallow traversal, returns the first view that matches the predicate.
 */
- (id<FRYLookup>)fry_firstDescendentMatching:(NSPredicate *)predicate;

/**
 * Perform a non exhaustive shallow search for children matching the predicate.  This will not
 * traverse children of a node that matches the predicate.
 */
- (NSSet *)fry_nonExhaustiveShallowSearchForChildrenMatching:(NSPredicate *)predicate;

@end
