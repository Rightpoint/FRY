//
//  FRYTouchHighlightWindow.m
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchHighlightWindowLayer.h"
#import "FRYTouchLayer.h"

typedef void(^FRYHighlightCompletionBlock)(void);

@interface FRYTouchHighlightWindowLayer()

@property (strong, nonatomic) NSMutableDictionary *touchLayerByKey;

@end


@implementation FRYTouchHighlightWindowLayer

- (void)enable
{
    [self updateLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLayer)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    [self showString:@"Recording Enabled"];
}

- (void)disable
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIWindowDidBecomeKeyNotification
                                                  object:nil];
    [self showString:@"Recording Complete"];
    [self removeFromSuperlayer];
}

- (void)updateLayer
{
    // Ensure that this layer is always on top by monitoring key window changes.
    CALayer *windowSuperLayer = [[[[UIApplication sharedApplication] keyWindow] layer] superlayer];
    self.bounds = windowSuperLayer.bounds;
    self.position = CGPointMake(CGRectGetMidX(windowSuperLayer.bounds),
                                CGRectGetMidY(windowSuperLayer.bounds));
    [windowSuperLayer insertSublayer:self above:windowSuperLayer];
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

- (void)visualizeEvent:(UIEvent *)event
{
    if ( [self superlayer] != nil ) {
        for (UITouch *touch in event.allTouches) {
            [self updateDisplayForTouch:touch];
        }
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

- (void)showString:(NSString *)string
{
    CATextLayer *label = [CATextLayer layer];
    [self.superlayer addSublayer:label];
    
    label.string = string;
    label.alignmentMode = kCAAlignmentCenter;
    label.fontSize = 18.0f;
    label.backgroundColor = [[UIColor darkGrayColor] CGColor];
    label.cornerRadius = 10.0f;
    label.frame = CGRectMake(0.0f, 0.0f, 180.0f, 24.0f);
    label.position = CGPointMake(CGRectGetWidth(self.bounds)  / 2, 100.0f);
    label.opacity = 0.0f;
    
    [[NSOperationQueue currentQueue] addOperationWithBlock:^{
        [self animateInLayerFrame:label animateOutAfter:1.5];
    }];
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

    [[NSOperationQueue currentQueue] addOperationWithBlock:^{
        [self animateInLayerFrame:layer animateOutAfter:0.3];
    }];
}

- (void)animateInLayerFrame:(CALayer *)layer animateOutAfter:(NSTimeInterval)delay
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(animateOutLayerFrame:) withObject:layer afterDelay:delay];
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
