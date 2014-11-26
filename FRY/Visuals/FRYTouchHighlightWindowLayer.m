//
//  FRYTouchHighlightWindow.m
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchHighlightWindowLayer.h"
#import "FRYTouchLayer.h"

static FRYTouchHighlightWindowLayer *fry_touchHighlightWindow = nil;

@interface FRYTouchHighlightWindowLayer()

@property (strong, nonatomic) NSMutableDictionary *touchLayerByKey;

@end


@implementation FRYTouchHighlightWindowLayer

+ (FRYTouchHighlightWindowLayer *)touchHighlightWindow
{
    return fry_touchHighlightWindow;
}

+ (void)enable
{
    if ( fry_touchHighlightWindow == nil ) {
        fry_touchHighlightWindow = [[FRYTouchHighlightWindowLayer alloc] init];
        [fry_touchHighlightWindow updateLayer];
        [[NSNotificationCenter defaultCenter] addObserver:fry_touchHighlightWindow
                                                 selector:@selector(updateLayer)
                                                     name:UIWindowDidBecomeKeyNotification
                                                   object:nil];
    }
}

+ (void)disable
{
    if ( fry_touchHighlightWindow != nil ) {
        [[NSNotificationCenter defaultCenter] removeObserver:fry_touchHighlightWindow
                                                        name:UIWindowDidBecomeKeyNotification
                                                      object:nil];
    }
    fry_touchHighlightWindow = nil;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.highlightViewFrames = YES;
        self.touchLayerByKey = [NSMutableDictionary dictionary];
        self.frameBorderColor = [UIColor colorWithRed:0.329 green:0.329 blue:0.329 alpha:1];
        self.touchColor = [UIColor colorWithRed:0.918 green:0.353 blue:0.322 alpha:1];

    }
    return self;
}

- (void)updateLayer
{
    // Ensure that this layer is always on top by monitoring key window changes.
    CALayer *windowSuperLayer = [[[[UIApplication sharedApplication] keyWindow] layer] superlayer];
    fry_touchHighlightWindow.bounds = windowSuperLayer.bounds;
    fry_touchHighlightWindow.position = CGPointMake(CGRectGetMidX(windowSuperLayer.bounds),
                                                    CGRectGetMidY(windowSuperLayer.bounds));
    [windowSuperLayer insertSublayer:fry_touchHighlightWindow above:windowSuperLayer];
}

- (void)visualizeEvent:(UIEvent *)event
{
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
                UIWindow *window = touch.view.window;
                CGRect frameInWindow = [window convertRect:touch.view.bounds fromView:touch.view];
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
    layer.position = self.position;
    self.touchLayerByKey[key] = layer;
    [self addSublayer:layer];
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
    [self addSublayer:layer];
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
