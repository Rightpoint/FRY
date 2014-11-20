//
//  TouchInteraction.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYActiveTouch.h"
#import "FRYPointInTime.h"
#import "FRYTouch.h"
#import "UITouch+FRY.h"

static CGFloat FRYDistanceBetweenPoints(CGPoint p1, CGPoint p2) {
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}
static NSUInteger const kFRYTouchPhaseUndefined = -1;

@interface FRYActiveTouch()

@property (strong, nonatomic) FRYTouch *touchDefinition;
@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) NSTimeInterval startTime;

@property (assign, nonatomic) CGPoint lastPointInWindow;
@property (strong, nonatomic) UITouch *currentTouch;

@end

@implementation FRYActiveTouch

- (id)initWithSimulatedTouch:(FRYTouch *)touch inView:(UIView *)view startTime:(NSTimeInterval)startTime;
{
    self = [super init];
    if ( self ) {
        _touchDefinition = touch;
        _view = view;
        _startTime = startTime;        
    }
    return self;
}

- (UITouchPhase)currentTouchPhase
{
    return self.currentTouch ? self.currentTouch.phase : kFRYTouchPhaseUndefined;
}


- (UITouch *)touchAtTime:(NSTimeInterval)currentTime
{

    NSTimeInterval relativeTime = currentTime - self.startTime;

    if ( relativeTime < self.touchDefinition.startingOffset ) {
        return nil;
    }
    
    CGPoint windowPoint = [self.touchDefinition pointAtRelativeTime:relativeTime];
    CGPoint viewPoint = [self.view.window convertPoint:windowPoint toView:self.view];

    if ( self.currentTouch == nil ) {
        UIWindow *window = [self.view isKindOfClass:[UIWindow class]] ? (id)self.view : self.view.window;
        self.currentTouch = [[UITouch alloc] initAtPoint:windowPoint inWindow:window];
    }
    else {
        [self.currentTouch setLocationInWindow:windowPoint];
        if ( relativeTime < [self.touchDefinition duration] + self.touchDefinition.startingOffset) {
            if ( FRYDistanceBetweenPoints(windowPoint, self.lastPointInWindow) > 1.0f ) {
                if ( CGRectContainsPoint(self.view.window.frame, windowPoint) ) {
                    [self.currentTouch setPhaseAndUpdateTimestamp:UITouchPhaseMoved];
                }
                else {
                    [self.currentTouch setPhaseAndUpdateTimestamp:UITouchPhaseCancelled];
                }
            }
            else {
                [self.currentTouch setPhaseAndUpdateTimestamp:UITouchPhaseStationary];
            }
        }
        else {
            [self.currentTouch setPhaseAndUpdateTimestamp:UITouchPhaseEnded];
            viewPoint = CGPointMake(-1.0f, -1.0f);
        }
    }
    
    self.lastPointInWindow = windowPoint;
    return self.currentTouch;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p touchDefinition=%@, startTime=%f view=%@ currentTouch=%@", self.class, self, self.touchDefinition, self.startTime, self.view, self.currentTouch];
}

@end
