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

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel
{
    NSParameterAssert(accessibilityLabel);
    return [NSPredicate predicateWithBlock:^BOOL(NSObject<UIAccessibilityIdentification> *object, NSDictionary *nope) {
        return [[object fry_accessibilityLabel] isEqualToString:accessibilityLabel];
    }];
}

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue
{
    NSParameterAssert(accessibilityLabel);
    NSParameterAssert(accessibilityValue);
    return [NSPredicate predicateWithBlock:^BOOL(NSObject<UIAccessibilityIdentification> *object, NSDictionary *nope) {
        return ( [[object fry_accessibilityLabel] isEqualToString:accessibilityLabel] &&
                 [[object fry_accessibilityValue] isEqualToString:accessibilityValue] );
    }];
}

+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel
{
    NSParameterAssert(accessibilityLabel);
    return [NSPredicate predicateWithBlock:^BOOL(NSObject<UIAccessibilityIdentification> *object, NSDictionary *nope) {
        return ([[object fry_accessibilityLabel] isEqualToString:accessibilityLabel] &&
                [object fry_accessibilityTraitsAreInteractable]);
    }];
}

+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue
{
    NSParameterAssert(accessibilityLabel);
    NSParameterAssert(accessibilityValue);
    return [NSPredicate predicateWithBlock:^BOOL(NSObject<UIAccessibilityIdentification> *object, NSDictionary *nope) {
        return ( [[object fry_accessibilityLabel] isEqualToString:accessibilityLabel] &&
                 [[object fry_accessibilityValue] isEqualToString:accessibilityValue] &&
                 [object fry_accessibilityTraitsAreInteractable]);
    }];
}


@end
