//
//  NSPredicate+FRY.m
//  FRY
//
//  Created by Brian King on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSPredicate+FRY.h"
#import "UIView+FRY.h"
#import "UIAccessibility+FRY.h"

@implementation NSPredicate(FRY)

+ (NSPredicate *)fry_matchAccessibilityIdentifier:(NSString *)accessibilityIdentifier
{
    return [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(accessibilityIdentifier)), accessibilityIdentifier];
}
+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel
{
    NSParameterAssert(accessibilityLabel);
    return [NSPredicate predicateWithFormat:@"%K = %@", NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel];
}

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue
{
    NSParameterAssert(accessibilityLabel);
    NSParameterAssert(accessibilityValue);
    return [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@",
            NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel,
            NSStringFromSelector(@selector(fry_accessibilityValue)), accessibilityValue];
}

+ (NSPredicate *)fry_matchAccessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    return [NSPredicate predicateWithBlock:^BOOL(NSObject<UIAccessibilityIdentification> *object, NSDictionary *nope) {
        return (object.accessibilityTraits & accessibilityTraits) == accessibilityTraits;
    }];
}

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel
                          accessibilityValue:(NSString *)accessibilityValue
                         accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    NSParameterAssert(accessibilityLabel);
    NSParameterAssert(accessibilityValue);
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[[self fry_matchAccessibilityLabel:accessibilityLabel accessibilityValue:accessibilityValue],
                                                                [self fry_matchAccessibilityTraits:accessibilityTraits]]];
}

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    NSParameterAssert(accessibilityLabel);
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[[self fry_matchAccessibilityLabel:accessibilityLabel],
                                                                [self fry_matchAccessibilityTraits:accessibilityTraits]]];
}


+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel
{
    NSParameterAssert(accessibilityLabel);
    return [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@",
            NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel,
            NSStringFromSelector(@selector(fry_accessibilityTraitsAreInteractable)), @(YES)];
}

+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue
{
    NSParameterAssert(accessibilityLabel);
    NSParameterAssert(accessibilityValue);
    return [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@ && %K = %@",
            NSStringFromSelector(@selector(fry_accessibilityLabel)), accessibilityLabel,
            NSStringFromSelector(@selector(fry_accessibilityValue)), accessibilityValue,
            NSStringFromSelector(@selector(fry_accessibilityTraitsAreInteractable)), @(YES)];
}


@end
