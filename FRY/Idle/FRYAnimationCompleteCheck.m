//
//  FRYAnimationCompleteCheck.m
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYAnimationCompleteCheck.h"
#import "UIApplication+FRY.h"

static NSMutableSet *fry_ignorePredicates = nil;

@implementation FRYAnimationCompleteCheck : FRYIdleCheck

+ (void)addIgnorePredicate:(NSPredicate *)predicate
{
    if ( fry_ignorePredicates == nil ) {
        fry_ignorePredicates = [NSMutableSet set];
    }
    [fry_ignorePredicates addObject:predicate];
}

+ (void)clearIgnorePredicates
{
    [fry_ignorePredicates removeAllObjects];
}

- (BOOL)isIdle
{
    return [self animatingViews].count == 0;
}

- (NSString *)busyDescription
{
    return [NSString stringWithFormat:@"%@ are still animating", [self animatingViews]];
}

- (NSArray *)animatingViews
{
    NSArray *views = [[UIApplication sharedApplication] fry_animatingViews];
    for ( NSPredicate *predicate in fry_ignorePredicates ) {
        views = [views filteredArrayUsingPredicate:[NSCompoundPredicate notPredicateWithSubpredicate:predicate]];
    }
    return views;
}

@end
