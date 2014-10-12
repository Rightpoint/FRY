//
//  FRYEventLog.m
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchEventLog.h"
#import "FRYPointInTime.h"

@interface FRYTouchEventLog()

@property (strong, nonatomic) NSArray *pointsInTime;

@end

@implementation FRYTouchEventLog

- (id)init
{
    self = [super init];
    if ( self ) {
        _pointsInTime = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray *)mutablePointsInTime
{
    return (id)_pointsInTime;
}

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time
{
    FRYPointInTime *pointInTime = [[FRYPointInTime alloc] initWithLocation:point offset:time];
    [[self mutablePointsInTime] addObject:pointInTime];
}

- (void)translateTouchesIntoViewCoordinates:(UIView *)view
{
    for ( FRYPointInTime *pointInTime in self.pointsInTime ) {
        pointInTime.location = [view.window convertPoint:pointInTime.location toView:view];
    }
}

- (NSString *)recreationCode
{
    return [NSString stringWithFormat:@"\
            [[FRY shared] simulateTouch:[FRYSyntheticTouch touchStarting:%f\n\
                                                              X:%@\n\
                                                              Y:%@\n\
                                                              offsets:%@]\n\
                                                              matchingView:%@]\n",
            self.startingOffset,
            [self recreationCodePointsXArgument],
            [self recreationCodePointsYArgument],
            [self recreationCodeOffsetsArgument],
            [self recreationCodeViewLookupVariables]];
}

- (NSString *)recreationCodePointsXArgument
{
    NSMutableArray *xPoints = [NSMutableArray arrayWithCapacity:self.pointsInTime.count];
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pointInTime, NSUInteger idx, BOOL *stop) {
        [xPoints addObject:@(pointInTime.location.x)];
    }];
    [xPoints addObject:@"nil"];
    return [xPoints componentsJoinedByString:@", "];
}

- (NSString *)recreationCodePointsYArgument
{
    NSMutableArray *xPoints = [NSMutableArray arrayWithCapacity:self.pointsInTime.count];
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pointInTime, NSUInteger idx, BOOL *stop) {
        [xPoints addObject:@(pointInTime.location.y)];
    }];
    [xPoints addObject:@"nil"];
    return [xPoints componentsJoinedByString:@", "];
}


- (NSString *)recreationCodeOffsetsArgument
{
    NSMutableArray *xPoints = [NSMutableArray arrayWithCapacity:self.pointsInTime.count];
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pointInTime, NSUInteger idx, BOOL *stop) {
        [xPoints addObject:@(pointInTime.offset)];
    }];
    [xPoints addObject:@"nil"];
    return [xPoints componentsJoinedByString:@", "];
}

- (NSString *)recreationCodeViewLookupVariables
{
    NSMutableString *result = [NSMutableString stringWithString:@"@{"];
    [self.viewLookupVariables enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [result appendFormat:@"@\"%@\" : @\"%@\"", key, obj];
    }];
    [result appendString:@"}"];
    if ( self.viewLookupVariables ) {
        return [result copy];
    }
    else {
        return @"nil";
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p pointsInTime=%@, startingOffset=%f, viewLookupVariables=%@", self.class, self, self.pointsInTime, self.startingOffset, self.viewLookupVariables];
}


@end
