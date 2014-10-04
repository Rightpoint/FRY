//
//  PointInTime.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYPointInTime : NSObject

+ (NSArray *)pointsFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint forDuration:(NSTimeInterval)duration;
+ (NSArray *)pointsAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration;
+ (NSArray *)pointsAlongPath:(UIBezierPath *)path forDuration:(NSTimeInterval)duration withOffset:(CGPoint)offset;

@property (assign, nonatomic) CGPoint location;
@property (assign, nonatomic) NSTimeInterval offset;

@end
