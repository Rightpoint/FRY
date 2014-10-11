//
//  FRYRecordedTouch.m
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYRecordedTouch.h"
#import "FRYSimulatedTouch+Private.h"


@implementation FRYRecordedTouch

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time
{
    FRYPointInTime *pointInTime = [[FRYPointInTime alloc] init];
    pointInTime.location = point;
    pointInTime.offset = time;
    [self.pointsInTime addObject:pointInTime];
}

@end
