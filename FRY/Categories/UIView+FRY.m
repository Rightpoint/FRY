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
    NSTimeInterval uptime = [[NSProcessInfo processInfo] systemUptime];
    BOOL isAnimating = NO;
    
    for (NSString *animationKey in self.layer.animationKeys ) {
        CAAnimation *animation = [self.layer animationForKey:animationKey];
        NSTimeInterval animationEnd = animation.beginTime + animation.duration + animation.timeOffset;

        if ( [animation.fillMode isEqualToString:kCAFillModeRemoved] ) {
            NSLog(@"Animating = %@ (To be removed)", animation);
            isAnimating = YES;
        }
        else if ( animationEnd > uptime ) {
            NSLog(@"Animating = %@ (Will End)", animation);
            isAnimating = YES;
        }
    }
    if ( isAnimating ) {
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
    UIView *view = self;
    while ( view && view.accessibilityLabel == nil ) {
        view = view.superview;
    }
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    if ( view.accessibilityLabel ) {
        variables[kFRYLookupAccessibilityLabel] = view.accessibilityLabel;
    }
    if ( view.accessibilityValue ) {
        variables[kFRYLookupAccessibilityValue] = view.accessibilityValue;
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

@implementation UISegmentedControl(FRY)

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