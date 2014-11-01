//
//  UIView+FRY.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIView+FRY.h"
#import "NSObject+FRYLookupSupport.h"
#import "FRY.h"

@implementation UIView (FRY)

- (UIView *)fry_animatingViewToWaitFor
{
    NSTimeInterval uptime = [[NSProcessInfo processInfo] systemUptime];
    BOOL isAnimating = NO;
    
    for (NSString *animationKey in self.layer.animationKeys ) {
        CAAnimation *animation = [self.layer animationForKey:animationKey];
        NSTimeInterval animationEnd = animation.beginTime + animation.duration + animation.timeOffset;

        if ( [animation.fillMode isEqualToString:kCAFillModeRemoved] ) {
            isAnimating = YES;
        }
        else if ( animationEnd > uptime ) {
            isAnimating = YES;
        }
    }
    if ( isAnimating ) {
        return self;
    }
    for ( UIView *subview in self.subviews ) {
        UIView *animatingSubview = [subview fry_animatingViewToWaitFor];
        if ( animatingSubview ) {
            return animatingSubview;
        }
    }
    return nil;
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

- (void)fry_simulateTouches:(NSArray *)touches insideRect:(CGRect)frameInView
{
    [[FRY shared] simulateTouches:touches inView:self frame:frameInView];
}

- (void)fry_simulateTouches:(NSArray *)touches
{
    [[FRY shared] simulateTouches:touches inView:self frame:self.bounds];
}

- (void)fry_simulateTouch:(FRYSimulatedTouch *)touch insideRect:(CGRect)frameInView
{
    [self fry_simulateTouches:@[touch] insideRect:frameInView];
}

- (void)fry_simulateTouch:(FRYSimulatedTouch *)touch
{
    [self fry_simulateTouches:@[touch]];
}

- (void)fry_simulateTouch:(FRYSimulatedTouch *)touch onSubviewMatching:(NSDictionary *)variables
{
    
}

- (void)fry_simulateTouches:(NSArray *)touches onSubviewMatching:(NSDictionary *)variables
{
    [self fry_enumerateDepthFirstViewMatching:variables usingBlock:^(UIView *view, CGRect frameInView) {
        [view fry_simulateTouches:touches insideRect:frameInView];
    }];
}


@end

@implementation UIActivityIndicatorView(FRY)

- (UIView *)fry_animatingViewToWaitFor
{
    return nil;
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