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

@end
