//
//  TouchInteraction.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiTouchDefinition;

@interface FRYTouchInteraction : NSObject

- (id)initWithPointsInTime:(NSArray *)pointsInTime inView:(UIView *)view startTime:(NSTimeInterval)startTime;

@property (assign, nonatomic, readonly) NSTimeInterval startTime;
@property (strong, nonatomic, readonly) NSArray *pointsInTime;
@property (strong, nonatomic, readonly) UIView *view;
@property (assign, nonatomic, readonly) UITouchPhase currentTouchPhase;

- (UITouch *)touchAtTime:(NSTimeInterval)currentTime;

@end
