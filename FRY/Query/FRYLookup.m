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

@interface FRYLookup()

@property (strong, nonatomic) id<FRYQuery> query;

@end

@implementation FRYLookup

+ (FRYLookup *)targetAccessibilityLabel:(NSString *)accessibilityLabel
                     accessibilityValue:(NSString *)accessibilityValue
                    accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    FRYLookup *target = [[FRYLookup alloc] init];
    target.query = [[FRYAccessibilityQuery alloc] initWithAccessibilityLabel:accessibilityLabel
                                                            accessibilityValue:accessibilityValue
                                                           accessibilityTraits:accessibilityTraits];
    return target;
}

+ (FRYLookup *)targetWithViewsMatchingPredicate:(NSPredicate *)predicate
{
    FRYLookup *target = [[FRYLookup alloc] init];
    target.query = [[FRYKeyValueTreeQuery alloc] initWithChildKeyPaths:@[NSStringFromSelector(@selector(subviews))] predicate:predicate];
    return target;
}

@end
