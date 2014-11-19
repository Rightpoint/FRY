//
//  FRYToucher.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYDefines.h"

@interface FRYTouchDispatch : NSObject

+ (FRYTouchDispatch *)shared;

- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame;

/**
 * Check to see if there are any active touches
 */
- (BOOL)hasActiveTouches;

/**
 *  Return the amount of time that the touch dispatch has touch intervals scheduled for.
 */
- (NSTimeInterval)maxTouchDuration;

/**
 * Clear out any touches and lookups.  This will send cancel events for any active touches to ensure that
 * the application state doesn't get munged.
 */
- (void)clearInteractionsAndTouches;

- (void)setMainThreadDispatchEnabled:(BOOL)enabled;

- (void)sendNextEvent;

@end