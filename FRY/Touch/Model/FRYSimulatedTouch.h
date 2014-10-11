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
 * The touch duration.
 */
- (NSTimeInterval)duration;

/**
 * Interpolate the touch position between the two closest specified points in time
 */
- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime;

@end


