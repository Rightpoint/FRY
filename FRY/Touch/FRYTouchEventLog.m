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
[FRY_KEY fry_simulateTouch:[%@ touchStarting:%.3f\n\
                                                points:%zd\n\
                                                xyoffsets:%@]\n\
         onSubviewMatching:%@];\n",
            self.translatedIntoView ? @"FRYSyntheticTouch" : @"FRYRecordedTouch",
            0.0,
            self.pointsInTime.count,
            [self recreationCodeXyoffsetsArgument],
            [self recreationCodeViewMatchingPredicate]];
}

- (NSString *)recreationCodeXyoffsetsArgument
{
    NSMutableArray *xPoints = [NSMutableArray arrayWithCapacity:self.pointsInTime.count];
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pointInTime, NSUInteger idx, BOOL *stop) {
        [xPoints addObject:[NSString stringWithFormat:@"%.3ff,%.3ff,%.3f", pointInTime.location.x, pointInTime.location.y, pointInTime.offset - self.startingOffset]];
    }];
    return [xPoints componentsJoinedByString:@", "];
}

- (NSString *)recreationCodeViewMatchingPredicate
{
    NSMutableArray *formatPairs = [NSMutableArray array];
    NSMutableArray *keyValuePairs = [NSMutableArray array];
    [self.viewLookupVariables enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [formatPairs addObject:@"\%K = \%@"];
        [keyValuePairs addObject:[NSString stringWithFormat:@"@\"%@\"", key]];
        if ( [obj isKindOfClass:[NSString class]] ) {
            [keyValuePairs addObject:[NSString stringWithFormat:@"@\"%@\"", obj]];
        }
        else if ( [obj isKindOfClass:[NSNumber class]] ) {
            [keyValuePairs addObject:[NSString stringWithFormat:@"@(%@)", obj]];
        }
        else {
            [NSException raise:NSInvalidArgumentException format:@"Not sure how to deal with %@", obj];
        }
    }];
    NSString *bareFormatString = [formatPairs componentsJoinedByString:@" && "];
    NSString *keyValueList = [keyValuePairs componentsJoinedByString:@", "];

    if ( self.viewLookupVariables ) {
        return [NSString stringWithFormat:@"[NSPredicate predicateWithFormat:@\"%@\", %@]", bareFormatString, keyValueList];
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
