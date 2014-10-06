//
//  FRYTouchDefinition.m
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchDefinition.h"
#import "FRYPointInTime.h"

@interface FRYTouchDefinition()

@property (strong, nonatomic, readonly) NSMutableArray *pointsInTime;

@end

@implementation FRYTouchDefinition

+ (FRYTouchDefinition *)touchFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration
{
    FRYTouchDefinition *definition = [[FRYTouchDefinition alloc] init];
    return definition;
}

+ (FRYTouchDefinition *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration
{
    FRYTouchDefinition *definition = [[FRYTouchDefinition alloc] init];
    return definition;
}

+ (FRYTouchDefinition *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration withOffset:(CGPoint)offset
{
    FRYTouchDefinition *definition = [[FRYTouchDefinition alloc] init];
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

@end
