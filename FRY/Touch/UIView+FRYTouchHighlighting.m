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
static NSTimeInterval const kFryUnhighlightAnimationDuration = 0.6f;
static CGFloat const kFryPointSize = 10.0f;

#pragma mark - FryHighlightView

@interface FRYHighlightView : UIView

@property (assign, nonatomic) BOOL showingFrame;
@property (assign, nonatomic) BOOL showingPoint;

@property (weak, nonatomic) UIView *frameView;
@property (weak, nonatomic) UIView *pointView;
@property (weak, nonatomic) CAEmitterLayer *pointEmitter;

@end

@implementation FRYHighlightView

- (UIView *)fry_animatingViewToWaitFor
{
    return nil;
}

@end

#pragma mark - FryTouchEmitter

@interface FryTouchEmitter : CAEmitterLayer
@end

@implementation FryTouchEmitter

+ (instancetype)layer
{
    FryTouchEmitter *emitter = [super layer];
    
    emitter.emitterShape = kCAEmitterLayerPoint;
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    UIImage *cellImage = [UIImage imageNamed:@"spark"];
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (id)cellImage.CGImage;
    cell.color = [UIColor orangeColor].CGColor;
    cell.scale = 1.2f * (kFryPointSize / cellImage.size.width);
    cell.birthRate = (1.0f / kFRYEventDispatchInterval) * 10.0f;
    cell.lifetime = 0.25f;
    cell.alphaSpeed = 4.0f;
    cell.scaleSpeed = -2.0f * cell.scale;
    
    emitter.emitterCells = @[cell];
    
    return emitter;
}

@end

#pragma mark - FRYTouchHighlighting

@implementation UIView (FRYTouchHighlighting)

- (void)fry_setFrameHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    NSTimeInterval animatedDuration = highlighted ? kFryHighlightAnimationDuration : kFryUnhighlightAnimationDuration;
    NSTimeInterval duration = animated ? animatedDuration : 0.0f;

    FRYHighlightView *highlightView = [self _fry_frameHighlightView];
    
    if ( !highlighted ) {
        [UIView animateWithDuration:duration animations:^{
            highlightView.frameView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if ( finished ) {
                highlightView.showingFrame = NO;
                [self _fry_cleanupFrameHighlightViewIfNeeded];
            }
        }];
    }
    else {
        if ( highlightView == nil ) {
            highlightView = [self _fry_setupFrameHighlightView];
        }
        
        highlightView.showingFrame = YES;
        
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            highlightView.frameView.alpha = 1.0f;
        } completion:nil];
    }
}

- (void)fry_highlightPoint:(CGPoint)point animated:(BOOL)animated
{
    BOOL highlighted = CGRectContainsPoint(self.bounds, point);
    
    NSTimeInterval animatedDuration = highlighted ? kFryHighlightAnimationDuration : kFryUnhighlightAnimationDuration;
    NSTimeInterval duration = animated ? animatedDuration : 0.0f;
    
    FRYHighlightView *highlightView = [self _fry_frameHighlightView];

    if ( !highlighted ) {
        [UIView animateWithDuration:duration animations:^{
            highlightView.pointView.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
            highlightView.pointView.alpha = 0.0f;
            highlightView.pointEmitter.opacity = 0.0f;
        } completion:^(BOOL finished) {
            if ( finished ) {
                highlightView.showingPoint = NO;
                [self _fry_cleanupFrameHighlightViewIfNeeded];
            }
        }];
    }
    else {
        if ( highlightView == nil ) {
            highlightView = [self _fry_setupFrameHighlightView];
        }
        
        if ( !highlightView.showingPoint ) {
            [UIView setAnimationsEnabled:NO];
            highlightView.pointView.center = point;
            highlightView.pointEmitter.emitterPosition = point;
            [UIView setAnimationsEnabled:YES];
            
            highlightView.showingPoint = YES;
        }
        
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            // set these every time so that the unhighlight animation will be cancelled
            highlightView.pointView.transform = CGAffineTransformIdentity;
            highlightView.pointView.alpha = 1.0f;
            highlightView.pointEmitter.opacity = 1.0f;
            
            highlightView.pointView.center = point;
            highlightView.pointEmitter.emitterPosition = point;
        } completion:nil];
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
    highlightView.backgroundColor = [UIColor clearColor];
    highlightView.opaque = NO;
    highlightView.userInteractionEnabled = NO;

    UIView *frameView = [[UIView alloc] initWithFrame:highlightView.bounds];
    frameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    frameView.backgroundColor = [UIColor clearColor];
    frameView.opaque = NO;
    frameView.layer.borderColor = [UIColor purpleColor].CGColor;
    frameView.layer.borderWidth = 2.0f;
    frameView.alpha = 0.0f;
    
    [highlightView addSubview:frameView];
    highlightView.frameView = frameView;
    
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kFryPointSize, kFryPointSize)];
    pointView.autoresizingMask = UIViewAutoresizingNone;
    pointView.backgroundColor = [UIColor orangeColor];
    pointView.userInteractionEnabled = NO;
    pointView.layer.cornerRadius = 0.5f * kFryPointSize;
    pointView.alpha = 0.0f;
    
    FryTouchEmitter *touchEmitter = [FryTouchEmitter layer];
    touchEmitter.opacity = 0.0f;
    
    [highlightView.layer addSublayer:touchEmitter];
    highlightView.pointEmitter = touchEmitter;
    
    [highlightView addSubview:pointView];
    highlightView.pointView = pointView;
    
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
