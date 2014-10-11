//
//  FRYQuery.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRYLookupResult;

@protocol FRYLookup <NSObject>

/**
 * Lookup children objects that match the specified variables.   These variables are matched by classes adopting FRYLookupSupport,
 * and returning a FRYLookup object that knows how to check that specific object type.
 */
#warning Not sure if it is valuable to return multiple objects here, or if we should behave like hitTest:event:, and return the result of the depth first search.
- (NSArray *)lookupChildrenOfObject:(NSObject *)object matchingVariables:(NSDictionary *)variables;

@end

typedef FRYLookupResult *(^FRYLookupResultTransform)(id object);

/**
 * This is a predicate driven lookup object.  One predicate determines a match, and the other predicate
 * determines if the children should be descended.
 */
@interface FRYLookup : NSObject <FRYLookup>

@property (strong, nonatomic) NSPredicate *matchPredicate;
@property (strong, nonatomic) NSPredicate *descendPredicate;
@property (copy, nonatomic) NSArray *childKeyPaths;
@property (copy, nonatomic) FRYLookupResultTransform matchTransform;

@end


