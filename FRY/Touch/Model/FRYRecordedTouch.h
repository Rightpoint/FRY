//
//  FRYRecordedTouch.h
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSimulatedTouch.h"

@interface FRYRecordedTouch : FRYSimulatedTouch

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time;

@property (assign, nonatomic) NSTimeInterval startingOffset;

@end
