//
//  FRYEventLog.m
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchEvent.h"
#import "FRYPointInTime.h"

@interface FRYTouchEvent()

@property (strong, nonatomic) NSArray *pointsInTime;
@property (assign, nonatomic) BOOL translatedIntoView;

@end

@implementation FRYTouchEvent

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
        CGPoint convertedLocation = [view convertPoint:pointInTime.location fromView:view.window];
        pointInTime.location = CGPointMake(convertedLocation.x / view.frame.size.width, convertedLocation.y / view.frame.size.height);
    }
    self.translatedIntoView = YES;
}

- (NSString *)recreationCode
{
    return [NSString stringWithFormat:@"FRY%@.touch(%@);",
            [self recreationCodeViewMatching],
            [self recreationTouchCode]];
}

- (NSString *)recreationTouchCode
{
    if ( self.pointsInTime.count == 2 ) {
        FRYPointInTime *pit = [self.pointsInTime lastObject];
        return [NSString stringWithFormat:@"[FRYTouch tapAtPoint:CGPointMake(%.3ff, %.3ff)]", pit.location.x, pit.location.y];
    }
    else {
        return [NSString stringWithFormat:@"[FRYTouch touchStarting:%.3f points:%zd %@:%@]",
                0.0,
                self.pointsInTime.count,
                self.translatedIntoView ? @"xyoffsets" : @"absoluteXyoffsets",
                [self recreationCodeXyoffsetsArgument]];
    }
}

- (NSString *)recreationCodeXyoffsetsArgument
{
    NSMutableArray *xPoints = [NSMutableArray arrayWithCapacity:self.pointsInTime.count];
    [self.pointsInTime enumerateObjectsUsingBlock:^(FRYPointInTime *pointInTime, NSUInteger idx, BOOL *stop) {
        [xPoints addObject:[NSString stringWithFormat:@"%.3ff,%.3ff,%.3f", pointInTime.location.x, pointInTime.location.y, pointInTime.offset - self.startingOffset]];
    }];
    return [xPoints componentsJoinedByString:@", "];
}

- (NSString *)recreationCodeViewMatching
{
    NSMutableString *result = [NSMutableString string];
    if ( self.viewLookupVariables ) {
        [self.viewLookupVariables enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            NSString *value = nil;
            if ( [obj isKindOfClass:[NSString class]] ) {
                value = [NSString stringWithFormat:@"@\"%@\"", obj];
            }
            else if ( [obj isKindOfClass:[NSNumber class]] ) {
                value = [NSString stringWithFormat:@"@(%@)", obj];
            }
            else {
                [NSException raise:NSInvalidArgumentException format:@"Not sure how to deal with %@", obj];
            }
            [result appendFormat:@".%@(%@)", [key stringByReplacingOccurrencesOfString:@"fry_" withString:@""], value];
        }];
    }
    return [result copy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p pointsInTime=%@, startingOffset=%f, viewLookupVariables=%@", self.class, self, self.pointsInTime, self.startingOffset, self.viewLookupVariables];
}

- (NSDictionary *)plistRepresentation
{
    return @{
             NSStringFromSelector(@selector(startingOffset)) : @(self.startingOffset),
             NSStringFromSelector(@selector(pointsInTime)) : [self.pointsInTime valueForKeyPath:NSStringFromSelector(@selector(arrayRepresentation))],
             NSStringFromSelector(@selector(viewLookupVariables)) : self.viewLookupVariables
             };
}

@end
