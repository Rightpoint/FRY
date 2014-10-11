//
//  FRYTouchDefinition.m
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSimulatedTouch+Private.h"
#import "FRYPointInTime.h"

@implementation FRYSimulatedTouch

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
        if ( pit.offset <= relativeTime ) {
            NSTimeInterval gapInterval = pit.offset;
            NSTimeInterval interPointInterval = relativeTime;
            if ( lastPit ) {
                gapInterval -= lastPit.offset;
                interPointInterval -= lastPit.offset;
            }
            CGFloat timeTranslate = gapInterval == 0 ? 1 : interPointInterval / gapInterval;
            result = CGPointMake(pit.location.x * timeTranslate, pit.location.y * timeTranslate);
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
