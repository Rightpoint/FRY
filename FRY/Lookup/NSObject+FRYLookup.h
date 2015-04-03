//
//  NSObject+FRYLookup.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"

/**
 *  Since all of NSObject "supports" accessibility, FRYLookup is supported
 *  by every object too. It may not actually work on all objects
 */
@interface NSObject(FRYLookup) <FRYLookup>

/**
 * Return a sort descriptor that will order an array of FRYLookup objects by origin
 */
+ (NSSortDescriptor *)fry_sortDescriptorByOrigin;

/**
 * Enable debugging on the specified object. Once a query hits one of the objects, all sub-object
 * predicate checks are logged to the console.
 */
+ (void)fry_enableLookupDebugForObjects:(NSArray *)objects;

@end

/**
 * Queries on UIApplication traverse all windows
 */
@interface UIApplication (FRYLookup) <FRYLookup>
@end

/**
 * Queries on UIAccessibilityElement's traverse the accessibility tree
 */
@interface UIAccessibilityElement(FRYLookup) <FRYLookup>
@end

/**
 * Queries on UIView traverse the accessibility tree and the subview tree.
 */
@interface UIView(FRYLookup) <FRYLookup>

/**
 * Disable the accessibility tree lookup by class. Some views (UITableView / UICollectionView)
 * behave very differently with accessibility lookups. Call [UITableView fry_setLookupAccessibilityChildren:NO]
 * to avoid this. Or fix your accessibility code
 */
+ (void)fry_setLookupAccessibilityChildren:(BOOL)lookupAccessibilityChildren;

@end