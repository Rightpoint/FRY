//
//  FRYTarget.m
//  FRY
//
//  Created by Brian King on 10/4/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTarget.h"
#import "FRYAccessibilityLookup.h"
#import "FRYKVTreeLookup.h"

@implementation FRYTarget

+ (FRYTarget *)targetAccessibilityLabel:(NSString *)accessibilityLabel
                     accessibilityValue:(NSString *)accessibilityValue
                    accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    FRYTarget *target = [[FRYTarget alloc] init];
    target.lookup = [[FRYAccessibilityLookup alloc] initWithAccessibilityLabel:accessibilityLabel
                                                            accessibilityValue:accessibilityValue
                                                           accessibilityTraits:accessibilityTraits];
    return target;
}

+ (FRYTarget *)targetWithViewsMatchingPredicate:(NSPredicate *)predicate
{
    FRYTarget *target = [[FRYTarget alloc] init];
    target.lookup = [[FRYKVTreeLookup alloc] initWithChildKeyPaths:@[NSStringFromSelector(@selector(subviews))] predicate:predicate];
    return target;
}

@end
