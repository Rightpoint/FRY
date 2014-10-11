//
//  FRYTouchDefinition.m
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSimulatedTouch.h"
#import "FRYPointInTime.h"

@interface FRYSimulatedTouch()

@property (strong, nonatomic, readonly) NSMutableArray *pointsInTime;

@end

@implementation FRYSimulatedTouch

+ (FRYSimulatedTouch *)touchFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration
{
    FRYSimulatedTouch *definition = [[FRYSimulatedTouch alloc] init];
    return definition;
}

+ (FRYSimulatedTouch *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration
{
    FRYSimulatedTouch *definition = [[FRYSimulatedTouch alloc] init];
    return definition;
}

+ (FRYSimulatedTouch *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration withOffset:(CGPoint)offset
{
    FRYSimulatedTouch *definition = [[FRYSimulatedTouch alloc] init];
    return definition;
}

- (id)init
{
    self = [super init];
    if ( self) {
        _pointsInTime = [NSMutableArray array];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FRYSimulatedTouch *copy  = [[self class] allocWithZone:zone];
    copy->_pointsInTime = [self.pointsInTime copyWithZone:zone];
    copy->_startingOffset = self.startingOffset;
    return copy;
}

- (FRYSimulatedTouch *)touchDelayedByOffset:(NSTimeInterval)offset
{
    FRYSimulatedTouch *touch = [self copy];
    touch->_startingOffset = offset;
    return touch;
}


- (NSTimeInterval)duration
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
#warning add boring maths
        }
        lastPit = pit;
    }];
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p pointsInTime=%@, startingOffset=%f", self.class, self, self.pointsInTime, self.startingOffset];
}

@end

@implementation FRYMutableSimulatedTouch

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time
{
    FRYPointInTime *pointInTime = [[FRYPointInTime alloc] init];
    pointInTime.location = point;
    pointInTime.offset = time;
    [self.pointsInTime addObject:pointInTime];
}

@end