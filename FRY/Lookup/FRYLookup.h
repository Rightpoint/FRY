//
//  FRYLookup.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYDefines.h"
#import "FRYLookupSupport.h"

/**
 * This protocol will add support for performing an NSPredicate search over an arbitrary tree structure.
 */
@protocol FRYLookup <FRYLookupSupport>

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

- (NSSet *)fry_allChildrenMatching:(NSPredicate *)predicate;
- (NSSet *)fry_allChildrenViewsMatching:(NSPredicate *)predicate;

@end
