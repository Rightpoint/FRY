//
//  UIAccessibilityElement+FRY.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIAccessibilityElement+FRY.h"

@implementation UIAccessibilityElement (FRY)

- (NSString *)id_accessibilityValue
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

- (UIView *)id_containingView
{
    UIAccessibilityElement *element = self;
    while ( element && ![element isKindOfClass:[UIView class]] ) {
        // Sometimes accessibilityContainer will return a view that's too far up the view hierarchy
        // UIAccessibilityElement instances will sometimes respond to view, so try to use that and then fall back to accessibilityContainer
        id view = [element respondsToSelector:@selector(view)] ? [(id)element view] : nil;
        
        if (view) {
            element = view;
        } else {
            element = [element accessibilityContainer];
        }
    }
    
    return (UIView *)element;
    
}

@end
