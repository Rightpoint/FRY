//
//  UIView+FRY.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIView+FRY.h"
#import "NSObject+FRYLookup.h"
#import "FRYTouchDispatch.h"
#import "UIAccessibility+FRY.h"
#import "FRYIdleCheck.h"

@implementation UIView (FRY)

- (BOOL)fry_isAnimating
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
    return isAnimating;
}

- (NSArray *)fry_reverseSubviews
{
    return [[self.subviews reverseObjectEnumerator] allObjects];
}

- (NSDictionary *)fry_matchingLookupVariables
{
    NSMutableDictionary *variables = [NSMutableDictionary dictionary];
    if ( self.fry_accessibilityLabel && self.accessibilityLabel.length > 0 ) {
        variables[NSStringFromSelector(@selector(fry_accessibilityLabel))] = self.fry_accessibilityLabel;
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

- (NSIndexPath *)fry_indexPathInContainer
{
    UIView *container = [self superview];
    while ( container && [container respondsToSelector:@selector(indexPathForCell:)] == NO ) {
        container = [container superview];
    }
    if ( container ) {
        return [container performSelector:@selector(indexPathForCell:) withObject:self];
    }
    else {
        return nil;
    }
}

- (UIView *)fry_lookupMatchingViewAtPoint:(CGPoint)point
{
    return [self hitTest:point withEvent:nil];
}

- (UIView *)fry_interactableParent
{
    UIView *testView = self;
    while ( testView &&
           [testView fry_accessibilityTraitsAreInteractable] == NO &&
           [testView isUserInteractionEnabled] == NO ) {
        testView = [testView superview];
    }
    return testView;
}

- (BOOL)fry_parentViewOfClass:(Class)klass
{
    BOOL matchingParent = NO;
    UIView *view = [self superview];
    while ( view ) {
        if ( [view isKindOfClass:klass] ) {
            matchingParent = YES;
            break;
        }
        view = [view superview];
    }
    return view;
}

- (BOOL)fry_simulateTouches:(NSArray *)touches insideRect:(CGRect)frameInView
{
    [[FRYTouchDispatch shared] simulateTouches:touches inView:self frame:frameInView];
    return [[FRYIdleCheck system] waitForIdle];
}

- (BOOL)fry_simulateTouches:(NSArray *)touches
{
    return [self fry_simulateTouches:touches insideRect:self.bounds];
}

- (BOOL)fry_simulateTouch:(FRYTouch *)touch insideRect:(CGRect)frameInView
{
    return [self fry_simulateTouches:@[touch] insideRect:frameInView];
}

- (BOOL)fry_simulateTouch:(FRYTouch *)touch
{
    return [self fry_simulateTouches:@[touch]];
}

- (BOOL)fry_simulateTouch:(FRYTouch *)touch onSubviewMatching:(NSPredicate *)predicate
{
    return [self fry_simulateTouches:@[touch] onSubviewMatching:predicate];
}

- (BOOL)fry_simulateTouches:(NSArray *)touches onSubviewMatching:(NSPredicate *)predicate
{
    BOOL touchOk = NO;
    if ( predicate ) {
        id <FRYLookup> lookup = [self fry_farthestDescendentMatching:predicate];
        UIView *view = [lookup fry_representingView];
        CGRect frameInView = [lookup fry_frameInView];
        NSAssert(view != nil, @"Unable to find view matching %@", predicate);
        
        // This interactable check is not really needed, but will cause some invalid touch events
        // to fail quicker.   It will also focus touches on views the developer is probably working with
        // and skip over some private view heirarchies.   This is especially noticible for the visualization
        // point of view.
        UIView *interactable = [view fry_interactableParent];
        NSAssert(interactable, @"No Interactable parent of %@", view);
        CGRect convertedFrame = [interactable convertRect:frameInView fromView:view];
        
        touchOk = [interactable fry_simulateTouches:touches insideRect:convertedFrame];
    }
    else {
        touchOk = [self fry_simulateTouches:touches insideRect:self.bounds];
    }
    return touchOk;
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
