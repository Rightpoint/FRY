//
//  FRYTouchDefinition.h
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

@interface FRYSimulatedTouch : NSObject <NSCopying>

/**
 * Create two touch definitions at the specified point.
 */
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

+ (FRYSimulatedTouch *)tapAtPoint:(CGPoint)point;
+ (FRYSimulatedTouch *)dragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
//+ (FRYSimulatedTouch *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration;
//+ (FRYSimulatedTouch *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration withOffset:(CGPoint)offset;

/**
 * The touch duration.
 */
- (NSTimeInterval)duration;

/**
 * Delay all touches in this definition by the offset.
 */
- (FRYSimulatedTouch *)touchDelayedByOffset:(NSTimeInterval)offset;

@property (assign, nonatomic, readonly) NSTimeInterval startingOffset;


/**
 * Interpolate the touch position between the two closest specified points in time
 */
- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime;

@end


@interface FRYMutableSimulatedTouch : FRYSimulatedTouch

- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time;

@property (assign, nonatomic) NSTimeInterval startingOffset;

@end