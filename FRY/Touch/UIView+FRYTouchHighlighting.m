//
//  UIView+FRYTouchHighlighting.m
//  FRY
//
//  Created by Rob Visentin on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIView+FRYTouchHighlighting.h"
#import "UIView+FRY.h"
#import "FRYDefines.h"

@import ObjectiveC.runtime;

static NSTimeInterval const kFryHighlightAnimationDuration = 0.1f;
static CGFloat const kFryPointSize = 10.0f;

#pragma mark - _FryHighlightView

@interface _FRYHighlightView : UIView
@end

@implementation _FRYHighlightView

- (UIView *)fry_animatingViewToWaitFor
{
    return nil;
}

@end

#pragma mark - _FryTouchEmitter

@interface _FryTouchEmitter : CAEmitterLayer
@end

@implementation _FryTouchEmitter

+ (instancetype)layer
{
    _FryTouchEmitter *emitter = [super layer];
    
    emitter.emitterShape = kCAEmitterLayerPoint;
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    UIImage *cellImage = [UIImage imageNamed:@"spark"];
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (id)cellImage.CGImage;
    cell.color = [UIColor orangeColor].CGColor;
    cell.scale = 1.2f * (kFryPointSize / cellImage.size.width);
    cell.birthRate = (1.0f / kFRYEventDispatchInterval);
    cell.lifetime = 0.5f;
    cell.alphaSpeed = 2.0f;
    cell.scaleSpeed = -cell.scale;
    
    emitter.emitterCells = @[cell];
    
    return emitter;
}

@end

#pragma mark - FRYTouchHighlighting

@implementation UIView (FRYTouchHighlighting)

- (void)fry_setFrameHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kFryHighlightAnimationDuration : 0.0f;

    UIView *frameView = [self _fry_frameHighlightView];
    
    if ( !highlighted ) {
        [UIView animateWithDuration:duration animations:^{
            frameView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [frameView removeFromSuperview];
        }];
        
        [self _fry_setFrameHighlightView:nil];
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
        [self _fry_setFrameHighlightView:frameView];
        
        [UIView animateWithDuration:duration animations:^{
            frameView.alpha = 1.0f;
        }];
        
    }
}

- (void)fry_highlightPoint:(CGPoint)point animated:(BOOL)animated
{
    NSTimeInterval duration = animated ? kFryHighlightAnimationDuration : 0.0f;

    UIView *pointView = objc_getAssociatedObject(self, _cmd);
    CAEmitterLayer *touchEmitter = [self _fry_activeTouchEmitter];
    
    if ( !CGRectContainsPoint(self.bounds, point) ) {
        [UIView animateWithDuration:duration animations:^{
            pointView.alpha = 0.0f;
            touchEmitter.opacity = 0.0f;
        } completion:^(BOOL finished) {
            [pointView removeFromSuperview];
            [touchEmitter removeFromSuperlayer];
        }];
        
        objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN);
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
            
            touchEmitter = [_FryTouchEmitter layer];
            touchEmitter.emitterPosition = point;
            touchEmitter.opacity = 0.0f;
            
            [[self _fry_frameHighlightView].layer addSublayer:touchEmitter];
            [self _fry_setActiveTouchEmitter:touchEmitter];
            
            [[self _fry_frameHighlightView] addSubview:pointView];
            objc_setAssociatedObject(self, _cmd, pointView, OBJC_ASSOCIATION_RETAIN);
            
            [UIView animateWithDuration:duration animations:^{
                pointView.alpha = 1.0f;
                touchEmitter.opacity = 1.0f;
            }];
        }
        else {
            [UIView animateWithDuration:duration animations:^{
                pointView.center = point;
                touchEmitter.emitterPosition = point;
            }];
        }
    }
}

#pragma mark - private methods

- (UIView *)_fry_frameHighlightView
{
    return objc_getAssociatedObject(self, @selector(_fry_frameHighlightView));
}

- (void)_fry_setFrameHighlightView:(UIView *)highlightView
{
    objc_setAssociatedObject(self, @selector(_fry_frameHighlightView), highlightView, OBJC_ASSOCIATION_RETAIN);
}

- (CAEmitterLayer *)_fry_activeTouchEmitter
{
    return objc_getAssociatedObject(self, @selector(_fry_activeTouchEmitter));
}

- (void)_fry_setActiveTouchEmitter:(CAEmitterLayer *)emitter
{
    objc_setAssociatedObject(self, @selector(_fry_activeTouchEmitter), emitter, OBJC_ASSOCIATION_RETAIN);
}

@end
