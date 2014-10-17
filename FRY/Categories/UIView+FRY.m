//
//  UIView+FRY.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIView+FRY.h"
#import "NSObject+FRYLookupSupport.h"

@implementation UIView (FRY)

- (BOOL)fry_hasAnimationToWaitFor
{
    if ( self.layer.animationKeys != nil && self.subviews.count > 0) {
        return YES;
    }
    for ( UIView *subview in self.subviews ) {
        if ( [subview fry_hasAnimationToWaitFor] ) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)fry_matchingLookupVariables
{
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    if ( self.accessibilityLabel ) {
        variables[kFRYLookupAccessibilityLabel] = self.accessibilityLabel;
    }
    if ( self.accessibilityValue ) {
        variables[kFRYLookupAccessibilityValue] = self.accessibilityValue;
    }

    if ( variables.count > 0 ) {
        return [variables copy];
    }
    else {
        return nil;
    }
}

- (UIView *)fry_lookupMatchingViewAtPoint:(CGPoint)point
{
    return [self hitTest:point withEvent:nil];
}

@end

@implementation UIActivityIndicatorView(FRY)

- (BOOL)fry_hasAnimationToWaitFor
{
    return NO;
}

@end

@implementation UINavigationBar(FRY)

- (UIView *)fry_lookupMatchingViewAtPoint:(CGPoint)point
{
    if ([self pointInside:point withEvent:nil]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            if ( [subview pointInside:convertedPoint withEvent:nil] ) {
                return subview;
            }
        }
        return self;
    }
    return nil;
}

@end