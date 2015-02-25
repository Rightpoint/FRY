//
//  UIView+FRYLookup.m
//  FRYolator
//
//  Created by Brian King on 2/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "UIView+FRYLookup.h"

@implementation UIView (FRYLookup)

- (UIView *)fry_lookupMatchingViewAtPoint:(CGPoint)point
{
    return [self hitTest:point withEvent:nil];
}

- (NSDictionary *)fry_matchingLookupVariables
{
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    if ( self.accessibilityLabel && self.accessibilityLabel.length > 0 ) {
        variables[NSStringFromSelector(@selector(accessibilityLabel))] = self.accessibilityLabel;
    }
    if ( self.accessibilityIdentifier && self.accessibilityIdentifier.length > 0 ) {
        variables[NSStringFromSelector(@selector(accessibilityIdentifier))] = self.accessibilityIdentifier;
    }

    if ( variables.count > 0 ) {
        return [variables copy];
    }
    else {
        return nil;
    }
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
