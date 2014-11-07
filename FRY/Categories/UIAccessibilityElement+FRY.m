//
//  UIAccessibilityElement+FRY.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIAccessibilityElement+FRY.h"

@implementation UIAccessibilityElement (FRY)

- (UIView *)fry_containingView
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
