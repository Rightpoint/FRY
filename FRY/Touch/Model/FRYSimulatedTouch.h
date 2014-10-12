//
//  FRYTouchDefinition.h
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

/**
 * A simulated touch models the touch sequence of one finger.   This object
 * is then asked for where the finger is at any given point in time.
 *
 * There are two subclasses to help manage the creation of touches, FRYSyntheticTouch and FRYRecordedTouch.
 * FRYSyntheticTouch generalizes coordinate spaces, and FRYRecordedTouch is used to record real touches.
 */
@interface FRYSimulatedTouch : NSObject <NSCopying>

+ (FRYSimulatedTouch *)touchStarting:(NSTimeInterval)startingOffset points:(NSUInteger)points xyoffsets:(double)xYorOffset, ...;

@property (assign, nonatomic, readonly) NSTimeInterval startingOffset;

/**
 * The touch duration.
 */
- (NSTimeInterval)duration;

/**
 * Interpolate the touch position between the two closest specified points in time
 */
- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime;

@end


