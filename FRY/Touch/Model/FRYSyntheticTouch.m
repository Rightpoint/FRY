//
//  FRYSyntheticTouch.m
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSyntheticTouch.h"
#import "FRYSimulatedTouch+Private.h"

static NSTimeInterval kFRYSwipeDefaultDuration = 0.6;
static NSTimeInterval kFRYPressDuration = 0.2;

static NSTimeInterval kFRYTouchLocationMid = 0.5f;
static NSTimeInterval kFRYSwipeLocationStart = 0.3f;
static NSTimeInterval kFRYSwipeLocationEnd   = 0.7f;

@implementation FRYSyntheticTouch

+ (FRYSyntheticTouch *)tap
{
    return [self tapAtPoint:CGPointMake(0.5, 0.5)];
}

+ (FRYSyntheticTouch *)tapAtPoint:(CGPoint)point
{
    FRYSyntheticTouch *definition = [[FRYSyntheticTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:point offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:point offset:0.05]];
    return definition;
}

+ (FRYSyntheticTouch *)dragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
{
    FRYSyntheticTouch *definition = [[FRYSyntheticTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:toPoint offset:duration]];
    return definition;
}

+ (FRYSyntheticTouch *)pressAndDragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration
{
    FRYSyntheticTouch *definition = [[FRYSyntheticTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:kFRYPressDuration]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:toPoint offset:duration]];
    return definition;
}

+ (FRYSyntheticTouch *)swipeInDirection:(FRYTouchDirection)direction
{
    return [self swipeInDirection:direction duration:kFRYSwipeDefaultDuration];
}

+ (FRYSyntheticTouch *)swipeInDirection:(FRYTouchDirection)direction duration:(NSTimeInterval)duration
{
    FRYSyntheticTouch *touch = nil;
    switch ( direction ) {
        case FRYTouchDirectionUp:
            touch = [self dragFromPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationStart)
                                toPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationEnd)
                            forDuration:duration];
            break;
        case FRYTouchDirectionDown:
            touch = [self dragFromPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationEnd)
                                toPoint:CGPointMake(kFRYTouchLocationMid, kFRYSwipeLocationStart)
                            forDuration:duration];
            break;
        case FRYTouchDirectionRight:
            touch = [self dragFromPoint:CGPointMake(kFRYSwipeLocationStart, kFRYTouchLocationMid)
                                toPoint:CGPointMake(kFRYSwipeLocationEnd,   kFRYTouchLocationMid)
                            forDuration:duration];
            break;
        case FRYTouchDirectionLeft:
            touch = [self dragFromPoint:CGPointMake(kFRYSwipeLocationEnd,   kFRYTouchLocationMid)
                                toPoint:CGPointMake(kFRYSwipeLocationStart, kFRYTouchLocationMid)
                            forDuration:duration];
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unknown touch direction %zd", direction];
    }
    return touch;
}


+ (NSArray *)pinchInToCenterOfPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration
{

    return @[];
}

+ (NSArray *)pinchOutFromCenterToPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration
{

    return @[];
}

+ (NSArray *)doubleTap
{
    return [self doubleTapAtPoint:CGPointMake(kFRYTouchLocationMid, kFRYTouchLocationMid)];
}

+ (NSArray *)doubleTapAtPoint:(CGPoint)point
{
    FRYSyntheticTouch *tap1 = [self tapAtPoint:point];
    FRYSyntheticTouch *tap2 = [[self tapAtPoint:point] touchDelayedByOffset:0.5];
    return @[tap1, tap2];
}

- (FRYSimulatedTouch *)touchInFrame:(CGRect)frame
{
    FRYSimulatedTouch *touch = [[FRYSimulatedTouch alloc] init];
    touch.startingOffset = self.startingOffset;
    for ( FRYPointInTime *pit in self.pointsInTime ) {
        CGPoint location = CGPointMake(pit.location.x * frame.size.width + frame.origin.x,
                                       pit.location.y * frame.size.height + frame.origin.y);
        [touch.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:location offset:pit.offset]];
    }
    return touch;
}

- (FRYSyntheticTouch *)touchDelayedByOffset:(NSTimeInterval)offset
{
    FRYSyntheticTouch *touch = [self copy];
    touch.startingOffset = offset;
    return touch;
}

@end
