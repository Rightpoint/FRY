//
//  FRYTouchDefinition.h
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;
#import "FRYDefines.h"

/**
 * A simulated touch models the touch sequence of one finger.   This object
 * is then asked for where the finger is at any given point in time.
 *
 * There are two subclasses to help manage the creation of touches, FRYSyntheticTouch and FRYRecordedTouch.
 * FRYSyntheticTouch generalizes coordinate spaces, and FRYRecordedTouch is used to record real touches.
 */
@interface FRYTouch : NSObject <NSCopying>

+ (FRYTouch *)touchStarting:(NSTimeInterval)startingOffset points:(NSUInteger)points xyoffsets:(double)xYorOffset, ...;
+ (FRYTouch *)touchStarting:(NSTimeInterval)startingOffset points:(NSUInteger)points absoluteXyoffsets:(double)xYorOffset, ...;
+ (FRYTouch *)tap;
+ (FRYTouch *)tapAtPoint:(CGPoint)point;
+ (FRYTouch *)dragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
+ (FRYTouch *)pressAndDragFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
+ (FRYTouch *)swipeInDirection:(FRYDirection)direction;
+ (FRYTouch *)swipeInDirection:(FRYDirection)direction duration:(NSTimeInterval)duration;
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
 * The touch duration.  This is the time of the last point plus the startingOffset.
 */
- (NSTimeInterval)duration;

/**
 * Specify an offset to delay the start of the touch, once the touch has been dispatched.
 */
@property (assign, nonatomic) NSTimeInterval startingOffset;

/**
 *  A flag to mark the touch as containing absolute positions, not relative positions.
 *  This defaults to NO, and specified points *should* be relative.  If absolute points
 * are used, be sure to set this to YES.
 */
@property (assign, nonatomic) BOOL pointsAreAbsolute;

/**
 * Add a point into the path of the touch
 */
- (void)addLocation:(CGPoint)point atRelativeTime:(NSTimeInterval)time;

/**
 * Return a touch in a real coordinate space.
 */
- (FRYTouch *)touchInFrame:(CGRect)frame;

/**
 * Interpolate the touch position between the two closest specified points in time
 */
- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime;

@end


