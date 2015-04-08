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

- (BOOL)fry_parentViewOfClass:(Class)cls
{
    BOOL matchingParent = NO;
    UIView *view = [self superview];
    while ( view ) {
        if ( [view isKindOfClass:cls] ) {
            matchingParent = YES;
            break;
        }
        view = [view superview];
    }
    return view != nil;
}

@end
