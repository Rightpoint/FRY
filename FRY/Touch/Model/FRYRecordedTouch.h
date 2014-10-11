//
//  FRYRecordedTouch.h
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSimulatedTouch.h"

/**
 * A recorded touch records an path of a finger in the window coordinate space.
 * This is really just a mutable FRYSimulatedTouch.
 */
@interface FRYRecordedTouch : FRYSimulatedTouch

/**
 * Add a point into the path of the touch
 */
- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time;

/**
 * Specify when the touch sequence begins.
 */
@property (assign, nonatomic) NSTimeInterval startingOffset;

@end
