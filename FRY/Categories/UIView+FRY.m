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

- (BOOL)fry_isOnScreen
{
    CGRect frameInWindow = [self.window convertRect:self.frame fromView:self.superview];
    return self.window && CGRectIntersectsRect(self.window.bounds, frameInWindow);
}

- (BOOL)fry_isVisible
{
    UIView *view = self;
    BOOL visible = NO;
    do {
        visible = view.alpha > 0.1 && view.hidden == NO;
        view = view.superview;
    } while ( view != nil && visible );
    return visible;
}

- (NSArray *)fry_reverseSubviews
{
    return [[self.subviews reverseObjectEnumerator] allObjects];
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
    return view != nil;
}

@end
