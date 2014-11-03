//
//  UIView+FRYTouchHighlighting.m
//  FRY
//
//  Created by Rob Visentin on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIView+FRYTouchHighlighting.h"
#import "UIView+FRY.h"

@import ObjectiveC.runtime;

static NSTimeInterval const kFryHighlightAnimationDuration = 0.1f;
static CGFloat const kFryPointSize = 5.0f;

@interface _FRYHighlightView : UIView
@end

@implementation _FRYHighlightView

- (UIView *)fry_animatingViewToWaitFor
{
    return nil;
}

@end

@implementation UIView (FRYTouchHighlighting)

- (void)fry_setFrameHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kFryHighlightAnimationDuration : 0.0f;

    UIView *frameView = objc_getAssociatedObject(self, _cmd);
    
    if ( !highlighted ) {
        [UIView animateWithDuration:duration animations:^{
            frameView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [frameView removeFromSuperview];
        }];
        
        objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else if ( frameView == nil ) {
        frameView = [[_FRYHighlightView alloc] initWithFrame:self.bounds];
        frameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        frameView.backgroundColor = [UIColor clearColor];
        frameView.opaque = NO;
        frameView.userInteractionEnabled = NO;
        frameView.alpha = 0.0f;
        
        frameView.layer.borderColor = [UIColor purpleColor].CGColor;
        frameView.layer.borderWidth = 2.0f;
        
        [self addSubview:frameView];
        objc_setAssociatedObject(self, _cmd, frameView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [UIView animateWithDuration:duration animations:^{
            frameView.alpha = 1.0f;
        }];
        
    }
}

- (void)fry_highlightPoint:(CGPoint)point animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kFryHighlightAnimationDuration : 0.0f;

    UIView *pointView = objc_getAssociatedObject(self, _cmd);
    
    if ( !CGRectContainsPoint(self.bounds, point) ) {
        [UIView animateWithDuration:duration animations:^{
            pointView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [pointView removeFromSuperview];
        }];
        
        objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    else {
        
        if ( pointView == nil ) {
            CGFloat pointRadius = 0.5f * kFryPointSize;
            
            pointView = [[_FRYHighlightView alloc] initWithFrame:CGRectMake(point.x - pointRadius, point.y - pointRadius, kFryPointSize, kFryPointSize)];
            pointView.autoresizingMask = UIViewAutoresizingNone;
            pointView.backgroundColor = [UIColor orangeColor];
            pointView.userInteractionEnabled = NO;
            pointView.alpha = 0.0f;
        
            pointView.layer.cornerRadius = pointRadius;
            
            [self addSubview:pointView];
            objc_setAssociatedObject(self, _cmd, pointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            [UIView animateWithDuration:duration animations:^{
                pointView.alpha = 1.0f;
            }];
        }
        else {
            [UIView animateWithDuration:duration animations:^{
                pointView.center = point;
            }];
        }
    }
}

@end
