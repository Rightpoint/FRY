//
//  UIAccessibility+FRY.m
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIAccessibility+FRY.h"

UIAccessibilityTraits FRYTextFieldAccessibilityValue = 0x00040000;

@implementation NSObject(FRY)

- (NSString *)fry_accessibilityValue
{
    // TODO: This is a temporary fix for an SDK defect.
    NSString *accessibilityValue = nil;
    @try {
        accessibilityValue = self.accessibilityValue;
    }
    @catch (NSException *exception) {
        NSLog(@"id: Unable to access accessibilityValue for element %@ because of exception: %@", self, exception.reason);
    }
    
    if ([accessibilityValue isKindOfClass:[NSAttributedString class]]) {
        accessibilityValue = [(NSAttributedString *)accessibilityValue string];
    }
    return accessibilityValue;
}

- (NSString *)fry_accessibilityLabel
{
    return [self.accessibilityLabel stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
}

- (NSArray *)fry_accessibilityElements
{
    if ( [self respondsToSelector:@selector(accessibilityElements)] ) {
        return self.accessibilityElements;
    }
    else {
        NSUInteger count = self.accessibilityElementCount == NSNotFound ? 0 : self.accessibilityElementCount;
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger accessibilityElementIndex = 0; accessibilityElementIndex < count; accessibilityElementIndex++) {
            NSObject *subelement = [self accessibilityElementAtIndex:accessibilityElementIndex];
            NSAssert(subelement != nil, @"");
            
            [result addObject:subelement];
        }
        return [result copy];
    }
}

- (BOOL)fry_accessibilityTraitsAreInteractable
{
    return ((self.accessibilityTraits & UIAccessibilityTraitButton) == UIAccessibilityTraitButton ||
            (self.accessibilityTraits & UIAccessibilityTraitAdjustable) == UIAccessibilityTraitAdjustable ||
            (self.accessibilityTraits & UIAccessibilityTraitAllowsDirectInteraction) == UIAccessibilityTraitAllowsDirectInteraction ||
            (self.accessibilityTraits & FRYTextFieldAccessibilityValue) == FRYTextFieldAccessibilityValue);
}

@end
