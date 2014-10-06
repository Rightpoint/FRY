//
//  FRYTouchDefinition.h
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

@interface FRYTouchDefinition : NSObject

/**
 * Create two touch definitions at the specified point.
 */
+ (NSArray *)doubleTapAtPoint:(CGPoint)point;

/**
 * Start the two finger positions and pinch inwards until the two fingers meet in the center
 */
+ (NSArray *)pinchInToCenterOfPoint:(CGPoint)finger1 point:(CGPoint)finger2;

/**
 * Start with the two fingers in the center of the two specified points.   Then pinch outwards
 * until the fingers stop at the points specified.
 */
+ (NSArray *)pinchOutFromCenterToPoint:(CGPoint)finger1 point:(CGPoint)finger2;

+ (FRYTouchDefinition *)tapAtPoint:(CGPoint)point;
+ (FRYTouchDefinition *)touchFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
+ (FRYTouchDefinition *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration;
+ (FRYTouchDefinition *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration withOffset:(CGPoint)offset;

@property (assign, nonatomic) NSTimeInterval startingOffset;

- (NSTimeInterval)endingTimeOffset;
- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime;

@end
