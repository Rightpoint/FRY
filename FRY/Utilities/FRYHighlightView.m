//
//  FRYHighlightView.m
//  FRY
//
//  Created by Rob Visentin on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYHighlightView.h"
#import "FRYDefines.h"
#import "UIView+FRY.h"
#import "Spark.png.h"

static NSTimeInterval const kFryHighlightAnimationDuration = 0.1f;
static NSTimeInterval const kFryUnhighlightAnimationDuration = 0.6f;
static CGFloat const kFryDefaultPointSize = 20.0f;

#pragma mark - FryTouchEmitter

@interface FRYHighlightView ()

@property (assign, nonatomic, readwrite) BOOL showingPoint;

@property (weak, nonatomic) UIView *frameView;
@property (weak, nonatomic) UIView *pointView;
@property (weak, nonatomic) CAEmitterLayer *pointEmitter;

@end

@implementation FRYHighlightView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        [self _buildView];
        self.pointSize = kFryDefaultPointSize;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( (self = [super initWithCoder:aDecoder]) ) {
        [self _buildView];
        self.pointSize = kFryDefaultPointSize;
    }
    return self;
}

#pragma mark - public methods

- (UIView *)fry_animatingViewToWaitFor
{
    return nil;
}

- (void)setPointSize:(CGFloat)pointSize
{
    _pointSize = pointSize;
    
    CGRect pointBounds = self.pointView.bounds;
    pointBounds.size = CGSizeMake(pointSize, pointSize);
    self.pointView.bounds = pointBounds;
    
    self.pointView.layer.cornerRadius = 0.5f * pointSize;
    
    self.pointEmitter.scale = (self.pointSize / [[self class] _pointEmitterImage].size.width) * [UIScreen mainScreen].scale;
}

- (void)setShowingFrame:(BOOL)showingFrame
{
    [self setShowingFrame:showingFrame animated:NO completion:nil];
}

- (void)setShowingFrame:(BOOL)showingFrame animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    NSTimeInterval animatedDuration = showingFrame ? kFryHighlightAnimationDuration : kFryUnhighlightAnimationDuration;
    NSTimeInterval duration = animated ? animatedDuration : 0.0f;
    
    if ( showingFrame ) {
        _showingFrame = YES;
        
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.frameView.alpha = 1.0f;
        } completion:nil];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
            self.frameView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if ( finished ) {
                _showingFrame = NO;
            }
            
            if ( completion != nil ) {
                completion(finished);
            }
        }];
    }
}

- (void)highlightPoint:(CGPoint)point animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    NSTimeInterval duration = animated ? kFryHighlightAnimationDuration : 0.0f;
    
    if ( !self.showingPoint ) {
        [UIView setAnimationsEnabled:NO];
        self.pointView.center = point;
        self.pointEmitter.emitterPosition = point;
        [UIView setAnimationsEnabled:YES];
        
        self.showingPoint = YES;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.pointView.transform = CGAffineTransformIdentity;
        self.pointView.alpha = 1.0f;
        self.pointEmitter.opacity = 1.0f;
        
        self.pointView.center = point;
        self.pointEmitter.emitterPosition = point;
    } completion:completion];
}

- (void)unhighlightPointAnimated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    NSTimeInterval duration = animated ? kFryUnhighlightAnimationDuration : 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        self.pointView.transform = CGAffineTransformMakeScale(3.0f, 3.0f);
        self.pointView.alpha = 0.0f;
        self.pointEmitter.opacity = 0.0f;
    } completion:^(BOOL finished) {
        if ( finished ) {
            self.showingPoint = NO;
        }
        
        if ( completion != nil ) {
            completion(finished);
        }
    }];
}

#pragma mark - private methods

+ (UIImage *)_pointEmitterImage
{
    static UIImage *pointEmitterImage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const unsigned char *pngBytes = spark_png;
        const unsigned int pngLength = spark_png_len;
        
        NSData *pngData = [NSData dataWithBytesNoCopy:(void *)pngBytes length:pngLength freeWhenDone:NO];
        pointEmitterImage = [UIImage imageWithData: pngData];
    });
    
    return pointEmitterImage;
}

- (void)_buildView
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.userInteractionEnabled = NO;
    
    UIView *frameView = [[UIView alloc] initWithFrame:self.bounds];
    frameView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    frameView.backgroundColor = [UIColor clearColor];
    frameView.opaque = NO;
    frameView.layer.borderColor = [UIColor purpleColor].CGColor;
    frameView.layer.borderWidth = 2.0f;
    frameView.alpha = 0.0f;
    
    [self addSubview:frameView];
    self.frameView = frameView;
    
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectZero];
    pointView.autoresizingMask = UIViewAutoresizingNone;
    pointView.backgroundColor = [UIColor orangeColor];
    pointView.userInteractionEnabled = NO;
    pointView.alpha = 0.0f;
    
    CAEmitterLayer *pointEmitter = [CAEmitterLayer layer];
    pointEmitter.emitterShape = kCAEmitterLayerPoint;
    pointEmitter.renderMode = kCAEmitterLayerAdditive;
    pointEmitter.opacity = 0.0f;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (id)[[self class] _pointEmitterImage].CGImage;
    cell.color = [UIColor orangeColor].CGColor;
    cell.birthRate = (1.0f / kFRYEventDispatchInterval);
    cell.lifetime = 0.25f;
    cell.alphaSpeed = 4.0f;
    cell.scaleSpeed = -1.5f;
    
    pointEmitter.emitterCells = @[cell];
    
    [self.layer addSublayer:pointEmitter];
    self.pointEmitter = pointEmitter;
    
    [self addSubview:pointView];
    self.pointView = pointView;
}

@end
