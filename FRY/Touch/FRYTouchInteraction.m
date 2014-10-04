//
//  TouchInteraction.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchInteraction.h"
#import "FRYPointInTime.h"
#import "UITouch+FRY.h"

static CGFloat FRYDistanceBetweenPoints(CGPoint p1, CGPoint p2) {
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

@interface FRYTouchInteraction()

@property (assign, nonatomic) NSTimeInterval startTime;
@property (strong, nonatomic) NSArray *pointsInTime;
@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) CGPoint lastPointInWindow;
@property (strong, nonatomic) UITouch *currentTouch;

@end

@implementation FRYTouchInteraction

- (id)initWithPointsInTime:(NSArray *)pointsInTime inView:(UIView *)view startTime:(NSTimeInterval)startTime
{
    self = [super init];
    if ( self ) {
        _pointsInTime = pointsInTime;
        _view = view;
        _startTime = startTime;
    }
    return self;
}

- (UITouchPhase)currentTouchPhase
{
    NSParameterAssert(self.currentTouch);
    return self.currentTouch.phase;
}

- (NSTimeInterval)endingTimeOffset
{
    FRYPointInTime *pointInTime = [self.pointsInTime lastObject];
    return pointInTime.offset;
}

- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime
{
    __block FRYPointInTime *lastPit = nil;
    __block CGPoint result = CGPointZero;
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pit, NSUInteger idx, BOOL *stop) {
        if ( pit.offset < relativeTime ) {
//            NSTimeInterval gapTime = lastPit.offset - pit.offset;
//            NSTimeInterval interPointInterval = relativeTime - lastPit.offset;

        }
        lastPit = pit;
    }];
    return result;
}

- (UITouch *)touchAtTime:(NSTimeInterval)currentTime
{
    NSTimeInterval relativeTime = currentTime - self.startTime;
    CGPoint point = [self pointAtRelativeTime:relativeTime];
    CGPoint windowPoint = [self.view.window convertPoint:point fromView:self.view];


    if ( self.currentTouch == nil ) {
        self.currentTouch = [[UITouch alloc] initAtPoint:windowPoint inWindow:self.view.window];
    }
    else {
        [self.currentTouch setLocationInWindow:windowPoint];
        if ( relativeTime < [self endingTimeOffset] ) {
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
        }
    }

    self.lastPointInWindow = windowPoint;
    return self.currentTouch;
}

@end
