//
//  FRYTouchLayer.m
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchLayer.h"
#import "FRYSpark.png.h"

static NSTimeInterval const kFRYStartFocusAnimationDuration = 0.15f;
static NSTimeInterval const kFRYFinishFocusAnimationDuration = 0.6f;
static CGAffineTransform kFRYOutOfFocusScaleTransform;
static CGFloat const kFRYPointSize = 15.0f;

@interface FRYTouchLayer()

@property (strong, nonatomic) CAEmitterLayer *emitter;
@property (strong, nonatomic) CALayer *point;
@property (strong, nonatomic) CAEmitterCell *cell;

@end

@implementation FRYTouchLayer

+ (void)load
{
    kFRYOutOfFocusScaleTransform = CGAffineTransformMakeScale(3.0f, 3.0f);
}

+ (UIImage *)pointEmitterImage
{
    static UIImage *pointEmitterImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *pngData   = [NSData dataWithBytesNoCopy:(void *)spark_png length:spark_png_len freeWhenDone:NO];
        pointEmitterImage = [UIImage imageWithData:pngData];
    });
    return pointEmitterImage;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        _cell = [CAEmitterCell emitterCell];
        _cell.contents = (id)[[self class] pointEmitterImage].CGImage;
        _cell.birthRate = (1.0f / 0.01);
        _cell.lifetime = 0.25f;
        _cell.alphaSpeed = 4.0f;
        _cell.scaleSpeed = -1.5f;

        _emitter = [CAEmitterLayer layer];
        _emitter.emitterShape = kCAEmitterLayerPoint;
        _emitter.renderMode = kCAEmitterLayerAdditive;
        _emitter.opacity = 0.0f;
        _emitter.scale = (kFRYPointSize / [[self class] pointEmitterImage].size.width) * [UIScreen mainScreen].scale;
        _emitter.emitterCells = @[_cell];
        [self addSublayer:_emitter];

        _point = [CALayer layer];
        _point.bounds = CGRectMake(0, 0, kFRYPointSize, kFRYPointSize);
        _point.cornerRadius = kFRYPointSize / 2;
        _point.affineTransform = kFRYOutOfFocusScaleTransform;

        [self addSublayer:_point];
    }
    return self;
}

- (void)setTouchColor:(CGColorRef)touchColor
{
    _cell.color = touchColor;
    _point.backgroundColor = touchColor;
}

- (void)setBounds:(CGRect)bounds
{
    self.emitter.bounds = bounds;
    [super setBounds:bounds];
}

- (void)startAtPoint:(CGPoint)point
{
    [self moveToPoint:point];
    [self performSelector:@selector(focusStart) withObject:nil afterDelay:0.0];
}

- (void)focusStart
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:kFRYStartFocusAnimationDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    self.point.affineTransform = CGAffineTransformIdentity;
    self.emitter.opacity = 1.0f;
    [CATransaction commit];
}

- (void)moveToPoint:(CGPoint)point
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.point.position = point;
    // I don't like that I have to do this, but moving self.emitter.position didn't help.   Missing something.
    self.emitter.emitterPosition = CGPointMake(self.position.x + point.x, self.position.y + point.y);
    [CATransaction commit];
}

- (void)finishAtPoint:(CGPoint)point
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:kFRYFinishFocusAnimationDuration];
    [CATransaction setCompletionBlock:^{
        [self removeFromSuperlayer];
    }];
    [self moveToPoint:point];
    self.opacity = 0.0f;
    self.point.affineTransform = kFRYOutOfFocusScaleTransform;
    self.point.opacity = 0.0f;
    [CATransaction commit];
}


@end
