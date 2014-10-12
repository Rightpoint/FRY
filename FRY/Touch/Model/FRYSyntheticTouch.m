//
//  FRYSyntheticTouch.m
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSyntheticTouch.h"
#import "FRYSimulatedTouch+Private.h"

#define FRYSyntheticTouchPointSpaceAssert(point) NSAssert(point.x >= 0 && point.x <= 1 && point.y >= 0 && point.y <= 1, @"Must specify point between 0 and 1")
#warning It is probably ok to allow points outside of 0-1, for touches that move beyond the edges of the touched view.  Be defensive for now.

@implementation FRYSyntheticTouch

+ (FRYSyntheticTouch *)tap
{
    return [self tapAtPoint:CGPointMake(0.5, 0.5)];
}

+ (FRYSyntheticTouch *)tapAtPoint:(CGPoint)point
{
    FRYSyntheticTouchPointSpaceAssert(point);
    FRYSyntheticTouch *definition = [[FRYSyntheticTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:point offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:point offset:0.05]];
    return definition;
}

+ (FRYSyntheticTouch *)dragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
{
    FRYSyntheticTouchPointSpaceAssert(fromPoint);
    FRYSyntheticTouchPointSpaceAssert(toPoint);
    FRYSyntheticTouch *definition = [[FRYSyntheticTouch alloc] init];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:fromPoint offset:0.0]];
    [definition.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:toPoint offset:duration]];
    return definition;
}

+ (NSArray *)pinchInToCenterOfPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration
{
    FRYSyntheticTouchPointSpaceAssert(finger1);
    FRYSyntheticTouchPointSpaceAssert(finger2);

    return @[];
}

+ (NSArray *)pinchOutFromCenterToPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration
{
    FRYSyntheticTouchPointSpaceAssert(finger1);
    FRYSyntheticTouchPointSpaceAssert(finger2);

    return @[];
}

+ (NSArray *)doubleTap
{
    return [self doubleTapAtPoint:CGPointMake(0.5, 0.5)];
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
