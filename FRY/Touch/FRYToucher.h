//
//  FRYToucher.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FRYTouchDefinition;

@interface FRYToucher : NSObject

@property (strong, nonatomic, readonly) UIApplication *application;

/**
 * Simulate a touch with a series of points in time in the view.
 * This method can be called on any thread
 */
- (void)simulateTouchDefinition:(FRYTouchDefinition *)touchDefinition inView:(UIView *)view;

/**
 * This method generates a UIEvent for the current state of the toucher.
 */
- (UIEvent *)eventForCurrentTouches;

- (void)sendNextEvent;

@end
