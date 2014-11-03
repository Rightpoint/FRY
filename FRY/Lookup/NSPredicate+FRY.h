//
//  NSPredicate+FRY.h
//  FRY
//
//  Created by Brian King on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSPredicate(FRY)

+ (NSPredicate *)fry_matchAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel;
+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue;

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel
                          accessibilityValue:(NSString *)accessibilityValue
                         accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel;
+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue;


@end
