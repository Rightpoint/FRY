//
//  NSPredicate+FRY.h
//  FRY
//
//  Created by Brian King on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPredicate(FRY)

+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel;
+ (NSPredicate *)fry_matchAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue;
+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel;
+ (NSPredicate *)fry_matchInteractableAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue;


@end
