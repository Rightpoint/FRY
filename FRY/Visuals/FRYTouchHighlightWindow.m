//
//  FRYTouchHighlightWindow.m
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchHighlightWindow.h"
#import "FRYTouchLayer.h"

static FRYTouchHighlightWindow *fry_touchHighlightWindow = nil;

@interface FRYTouchHighlightWindow()

@property (strong, nonatomic) NSMutableDictionary *touchLayerByKey;

@end


@implementation FRYTouchHighlightWindow

+ (FRYTouchHighlightWindow *)touchHighlightWindow
{
    return fry_touchHighlightWindow;
}

+ (void)enable
{
    if ( fry_touchHighlightWindow == nil ) {
        fry_touchHighlightWindow = [[FRYTouchHighlightWindow alloc] init];
        [[self touchHighlightWindow] makeKeyAndVisible];
    }
}

+ (void)disable
{
    fry_touchHighlightWindow = nil;
}

- (instancetype)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if ( self ) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.highlightViewFrames = YES;
        self.touchLayerByKey = [NSMutableDictionary dictionary];
        self.frameBorderColor = [UIColor colorWithRed:0.329 green:0.329 blue:0.329 alpha:1];
        self.touchColor = [UIColor colorWithRed:0.918 green:0.353 blue:0.322 alpha:1];

    }
    return self;
}

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    for (UITouch *touch in event.allTouches) {
        [self updateDisplayForTouch:touch];
    }
}

- (void)updateDisplayForTouch:(UITouch *)touch
{
    NSValue *key = [NSValue valueWithNonretainedObject:touch];
    CGPoint locationInWindow = [touch locationInView:nil];
    switch (touch.phase) {
        case UITouchPhaseBegan: {
            [self beginTouchWithKey:key atPoint:locationInWindow];
            if ( touch.view && self.highlightViewFrames ) {
                CGRect frameInWindow = [self convertRect:touch.view.bounds fromView:touch.view];
                [self highlightFrame:frameInWindow];
            }
            break;
        }
        case UITouchPhaseMoved:
            [self updateTouchWithKey:key atPoint:locationInWindow];
            break;
        case UITouchPhaseCancelled: // Handle cancel and end the same
        case UITouchPhaseEnded:
            [self endTouchWithKey:key atPoint:locationInWindow];
            break;
        default:
            break;
    }
}

- (FRYTouchLayer *)newTouchLayerForKey:(id<NSCopying>)key
{
    FRYTouchLayer *layer = [FRYTouchLayer layer];
    layer.touchColor = self.touchColor.CGColor;
    layer.bounds = self.bounds;
    layer.position = self.center;
    self.touchLayerByKey[key] = layer;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)beginTouchWithKey:(id<NSCopying>)key atPoint:(CGPoint)point
{
    NSParameterAssert(key);
    NSAssert(self.touchLayerByKey[key] == nil, @"Already have a touch for the key");
    FRYTouchLayer *layer = [self newTouchLayerForKey:key];
    
    [layer startAtPoint:point];
}

- (void)updateTouchWithKey:(id<NSCopying>)key atPoint:(CGPoint)point
{
    NSParameterAssert(key);
    NSAssert(self.touchLayerByKey[key] != nil, @"Do not have a touch for the key");

    FRYTouchLayer *layer = self.touchLayerByKey[key];
    [layer moveToPoint:point];
}

- (void)endTouchWithKey:(id<NSCopying>)key atPoint:(CGPoint)point
{
    NSParameterAssert(key);
    NSAssert(self.touchLayerByKey[key] != nil, @"Do not have a touch for the key");

    FRYTouchLayer *layer = self.touchLayerByKey[key];
    [self.touchLayerByKey removeObjectForKey:key];
    [layer finishAtPoint:point];
}

- (void)highlightFrame:(CGRect)frame
{
    CGPoint position = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) / 2,
                                   CGRectGetMinY(frame) + CGRectGetHeight(frame) / 2);
    frame.origin = CGPointZero;

    CALayer *layer = [CALayer layer];
    layer.bounds = frame;
    layer.position = position;
    layer.opacity = 0.0f;
    layer.borderWidth = 2.0f;
    layer.borderColor = self.frameBorderColor.CGColor;
    [self.layer addSublayer:layer];
    [self performSelector:@selector(animateInLayerFrame:) withObject:layer afterDelay:0.0];
}

- (void)animateInLayerFrame:(CALayer *)layer
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(animateOutLayerFrame:) withObject:layer afterDelay:0.3];
    }];
    layer.opacity = 1.0f;
    [CATransaction commit];
}

- (void)animateOutLayerFrame:(CALayer *)layer
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [layer removeFromSuperlayer];
    }];
    layer.opacity = 0.0f;
    [CATransaction commit];
}

@end
