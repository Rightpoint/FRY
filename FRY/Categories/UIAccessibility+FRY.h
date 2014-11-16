//
//  UIAccessibility+FRY.h
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIAccessibility.h>

OBJC_EXTERN UIAccessibilityTraits FRYTextFieldAccessibilityValue;
OBJC_EXTERN UIAccessibilityTraits FRYAccessibilityTraitContainer;

@interface NSObject(FRY)

- (NSString *)fry_accessibilityLabel;
- (NSString *)fry_accessibilityValue;
- (NSArray *)fry_accessibilityElements;
- (BOOL)fry_accessibilityTraitsAreInteractable;

@end
