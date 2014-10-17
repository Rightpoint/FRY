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
@property (assign, nonatomic) BOOL translatedIntoView;

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
        CGPoint convertedLocation = [view.window convertPoint:pointInTime.location toView:view];
        pointInTime.location = CGPointMake(convertedLocation.x / view.frame.size.width, convertedLocation.y / view.frame.size.height);
    }
    self.translatedIntoView = YES;
}

- (NSString *)recreationCode
{
    return [NSString stringWithFormat:@"\
[[FRY shared] simulateTouch:[%@ touchStarting:%.3f\n\
                                                      points:%zd\n\
                                                   xyoffsets:%@]\n\
               matchingView:%@];\n",
            self.translatedIntoView ? @"FRYSyntheticTouch" : @"FRYRecordedTouch",
            self.startingOffset,
            self.pointsInTime.count,
            [self recreationCodeXyoffsetsArgument],
            [self recreationCodeViewLookupVariables]];
}

- (NSString *)recreationCodeXyoffsetsArgument
{
    NSMutableArray *xPoints = [NSMutableArray arrayWithCapacity:self.pointsInTime.count];
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pointInTime, NSUInteger idx, BOOL *stop) {
        [xPoints addObject:[NSString stringWithFormat:@"%.3ff,%.3ff,%.3f", pointInTime.location.x, pointInTime.location.y, pointInTime.offset - self.startingOffset]];
    }];
    return [xPoints componentsJoinedByString:@", "];
}

- (NSString *)recreationCodeViewLookupVariables
{
    NSMutableArray *keyPairs = [NSMutableArray array];
    [self.viewLookupVariables enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [keyPairs addObject:[NSString stringWithFormat:@"@\"%@\" : @\"%@\"", key, obj]];
    }];
    if ( self.viewLookupVariables ) {
        return [NSString stringWithFormat:@"@{%@}", [keyPairs componentsJoinedByString:@", "]];
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
