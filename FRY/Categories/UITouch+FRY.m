//
//  UITouch+FRY.m
//  FRY
//
//  Created by Brian King on 10/4/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UITouch+FRY.h"

@import ObjectiveC.runtime;

typedef struct {
    unsigned int _firstTouchForView:1;
    unsigned int _isTap:1;
    unsigned int _isDelayed:1;
    unsigned int _sentTouchesEnded:1;
    unsigned int _abandonForwardingRecord:1;
} UITouchFlags;

static const void *FRYUITouchViewWhereTouchBegan = &FRYUITouchViewWhereTouchBegan;


@interface UITouch ()

@property(assign) BOOL isTap;
@property(assign) NSUInteger tapCount;
@property(assign) UITouchPhase phase;
@property(retain) UIView *view;
@property(retain) UIWindow *window;
@property(assign) NSTimeInterval timestamp;

- (void)setGestureView:(UIView *)view;
- (void)_setLocationInWindow:(CGPoint)location resetPrevious:(BOOL)resetPrevious;
- (void)_setIsFirstTouchForView:(BOOL)firstTouchForView;

@end

@implementation UITouch (KIFAdditions)

- (id)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window;
{
    NSParameterAssert(window);
    self = [super init];
    if ( self ) {
        // Wipes out some values.  Needs to be first.
        [self setWindow:window];
        
        [self setTapCount:1];
        [self _setLocationInWindow:point resetPrevious:YES];
        
        UIView *viewWhereTouchBegan = [window hitTest:point withEvent:nil];
        [self setView:viewWhereTouchBegan];
        [self setPhase:UITouchPhaseBegan];
        [self _setIsFirstTouchForView:YES];
        [self setIsTap:YES];
        [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
        
        if ([self respondsToSelector:@selector(setGestureView:)]) {
            [self setGestureView:viewWhereTouchBegan];
        }
    }
    
    return self;
}

//
// setLocationInWindow:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location
{
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self _setLocationInWindow:location resetPrevious:NO];
}

- (void)setPhaseAndUpdateTimestamp:(UITouchPhase)phase
{
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self setPhase:phase];
}

- (CGPoint)fry_locationRelativeToView
{
    NSParameterAssert(self.view);
    CGPoint location = [self locationInView:self.view];
    return CGPointMake(location.x / self.view.frame.size.width, location.y / self.view.frame.size.height);
}

@end
