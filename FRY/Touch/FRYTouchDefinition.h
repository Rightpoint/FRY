//
//  FRYTouchDefinition.h
//  FRY
//
//  Created by Brian King on 10/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

@interface FRYTouchDefinition : NSObject

+ (FRYTouchDefinition *)touchFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
+ (FRYTouchDefinition *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration;
+ (FRYTouchDefinition *)touchAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration withOffset:(CGPoint)offset;

- (NSTimeInterval)endingTimeOffset;
- (CGPoint)pointAtRelativeTime:(NSTimeInterval)relativeTime;

@end
