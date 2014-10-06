//
//  FRYTarget.m
//  FRY
//
//  Created by Brian King on 10/4/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYLookup.h"
#import "FRYAccessibilityQuery.h"
#import "FRYKeyValueTreeQuery.h"
#import "FRYQuery.h"

@interface FRYLookup()

@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) id<FRYQuery> query;
@property (copy, nonatomic) FRYQueryResult whenFound;

@end

@implementation FRYLookup

+ (FRYLookup *)lookupAccessibilityLabel:(NSString *)accessibilityLabel
                     accessibilityValue:(NSString *)accessibilityValue
                    accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
                              whenFound:(FRYSingularQueryResult)found
{
    FRYLookup *lookup = [[FRYLookup alloc] init];
    lookup.query = [[FRYAccessibilityQuery alloc] initWithAccessibilityLabel:accessibilityLabel
                                                            accessibilityValue:accessibilityValue
                                                           accessibilityTraits:accessibilityTraits];
    lookup.whenFound = ^(NSArray *results) {
        NSParameterAssert(results.count == 1);
        found(results.firstObject);
    };
    return lookup;
}

+ (FRYLookup *)lookupViewsMatchingPredicate:(NSPredicate *)predicate whenFound:(FRYQueryResult)found;
{
    FRYLookup *lookup = [[FRYLookup alloc] init];
    lookup.query = [[FRYKeyValueTreeQuery alloc] initWithChildKeyPaths:@[NSStringFromSelector(@selector(subviews))] predicate:predicate];
    lookup.whenFound = found;
    return lookup;
}

- (NSArray *)queryWindows
{
    NSArray *queryWindows = nil;
    switch ( self.targetWindow ) {
        case FRYTargetWindowAll:
            queryWindows = [self.application windows];
            break;
        case FRYTargetWindowKey:
            queryWindows = @[[self.application keyWindow]];
    }
    return queryWindows;
}

- (FRYLookupComplete)foundBlockIfLookupIsFound
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSAssert(self.whenFound != nil, @"");
    NSArray *results = @[];
    for ( UIWindow *window in [self queryWindows] ) {
        NSArray *subResults = [self.query lookForMatchingObjectsStartingFrom:window];
        results = [results arrayByAddingObjectsFromArray:subResults];
    }
    FRYLookupComplete foundBlock = nil;
    if ( results.count > 0 ) {
        foundBlock = [^() {
            self.whenFound(results);
        } copy];
    }
    return foundBlock;
}

@end
