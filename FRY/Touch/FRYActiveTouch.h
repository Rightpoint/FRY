//
//  TouchInteraction.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRYTouch;

/**
 * This represents an active touch, and manages the state of the FRYSimulatedTouch and generates UITouch objects.
 */
@interface FRYActiveTouch : NSObject

- (id)initWithSimulatedTouch:(FRYTouch *)touch inView:(UIView *)view startTime:(NSTimeInterval)startTime;

@property (assign, nonatomic, readonly) NSTimeInterval startTime;
@property (strong, nonatomic, readonly) UIView *view;
@property (assign, nonatomic, readonly) UITouchPhase currentTouchPhase;
@property (strong, nonatomic, readonly) FRYTouch *touchDefinition;

- (UITouch *)touchAtTime:(NSTimeInterval)currentTime;

@end
