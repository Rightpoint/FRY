//
//  UIView+FRYTouchHighlighting.m
//  FRY
//
//  Created by Rob Visentin on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIView+FRYTouchHighlighting.h"
#import "FRYHighlightView.h"

@import ObjectiveC.runtime;

#pragma mark - FRYTouchHighlighting

@implementation UIView (FRYTouchHighlighting)

- (void)fry_setFrameHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    FRYHighlightView *highlightView = [self _fry_frameHighlightView];
    
    if ( !highlighted ) {
        [highlightView setShowingFrame:NO animated:animated completion:^(BOOL finished) {
            if ( finished ) {
                [self _fry_cleanupFrameHighlightViewIfNeeded];
            }
        }];
    }
    else {
        if ( highlightView == nil ) {
            highlightView = [self _fry_setupFrameHighlightView];
        }
        
        [highlightView setShowingFrame:YES animated:animated completion:nil];
    }
}

- (void)fry_highlightPoint:(CGPoint)point animated:(BOOL)animated
{
    BOOL highlighted = CGRectContainsPoint(self.bounds, point);
    
    FRYHighlightView *highlightView = [self _fry_frameHighlightView];

    if ( !highlighted ) {
        [highlightView unhighlightPointAnimated:animated completion:^(BOOL finished) {
            if ( finished ) {
                [self _fry_cleanupFrameHighlightViewIfNeeded];
            }
        }];
    }
    else {
        if ( highlightView == nil ) {
            highlightView = [self _fry_setupFrameHighlightView];
        }
        
        [highlightView highlightPoint:point animated:animated completion:nil];
    }
}

#pragma mark - private methods

- (FRYHighlightView *)_fry_frameHighlightView
{
    return objc_getAssociatedObject(self, @selector(_fry_frameHighlightView));
}

- (void)_fry_setFrameHighlightView:(FRYHighlightView *)highlightView
{
    objc_setAssociatedObject(self, @selector(_fry_frameHighlightView), highlightView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FRYHighlightView *)_fry_setupFrameHighlightView
{
    FRYHighlightView *highlightView = [[FRYHighlightView alloc] initWithFrame:self.bounds];
    highlightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:highlightView];
    [self _fry_setFrameHighlightView:highlightView];
    
    return highlightView;
}

- (void)_fry_cleanupFrameHighlightViewIfNeeded
{
    FRYHighlightView *highlightView = [self _fry_frameHighlightView];
    
    if ( !highlightView.showingFrame && !highlightView.showingPoint ) {
        [highlightView removeFromSuperview];
        [self _fry_setFrameHighlightView:nil];
    }
}

@end
