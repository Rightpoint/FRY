//
//  FRYSyntheticTouch.h
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSimulatedTouch.h"

/**
 * A synthetic touch is a touch to be created programatically.  It is oblivious to absolute coordinate space.
 *
 * The coordinate system for a synthetic touch is x(0-1), y(0-1).   This defines
 * a relative touch which is then extrapolated into a frame with 'touchInFrame:' before use.
 */
@interface FRYSyntheticTouch : FRYSimulatedTouch

+ (FRYSyntheticTouch *)tap;
+ (FRYSyntheticTouch *)tapAtPoint:(CGPoint)point;
+ (FRYSyntheticTouch *)dragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;

+ (NSArray *)doubleTap;
+ (NSArray *)doubleTapAtPoint:(CGPoint)point;

/**
 * Start the two finger positions and pinch inwards until the two fingers meet in the center
 */
+ (NSArray *)pinchInToCenterOfPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration;

/**
 * Start with the two fingers in the center of the two specified points.   Then pinch outwards
 * until the fingers stop at the points specified.
 */
+ (NSArray *)pinchOutFromCenterToPoint:(CGPoint)finger1 point:(CGPoint)finger2 withDuration:(NSTimeInterval)duration;

/**
 * Return a touch in a real coordinate space.
 */
- (FRYSimulatedTouch *)touchInFrame:(CGRect)frame;

/**
 * Create a new touch that is delayed by some time offset.
 */
- (FRYSyntheticTouch *)touchDelayedByOffset:(NSTimeInterval)offset;


@end
