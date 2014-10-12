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

+ (FRYSimulatedTouch *)touchStarting:(NSTimeInterval)startingOffset points:(NSUInteger)points xyoffsets:(double)xYorOffset, ...
{
    FRYSimulatedTouch *touch = [[self alloc] init];
    touch.startingOffset = startingOffset;
    va_list args;
    va_start(args, xYorOffset);
    for ( NSUInteger i = 0; i < points; i++ ) {
        CGFloat x = i == 0 ? xYorOffset : va_arg(args, double);
        CGFloat y = va_arg(args, double);
        NSTimeInterval offset = va_arg(args, double);
        
        [touch.pointsInTime addObject:[[FRYPointInTime alloc] initWithLocation:CGPointMake(x, y) offset:offset]];
    }
    
    return touch;
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

- (NSTimeInterval)duration
{
    FRYPointInTime *pointInTime = [self.pointsInTime lastObject];
    return pointInTime.offset;
}

- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime
{
    // don't over-translate, max out the relative time to the duration.
    relativeTime = MIN(relativeTime, self.duration);
    
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
