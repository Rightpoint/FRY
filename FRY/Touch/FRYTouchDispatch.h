//
//  FRYToucher.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYDefines.h"

@protocol FRYTouchDispatchDelegate;

@interface FRYTouchDispatch : NSObject

+ (FRYTouchDispatch *)shared;

/**
 *  The delegate to inform of synchronous touch operations.  This will defer the waiting
 *  behavior to the delegate, rather than just waiting for the touches to complete.
 */
@property (weak, nonatomic) id<FRYTouchDispatchDelegate>delegate;

/**
 *  Synchronously dispatch the specified touches.  This will block as described in the delegate.
 *
 *  @param touches An array of touch objects to dispatch
 *  @param view    The view to dispatch the touches in
 *  @param frame   The rect in the view to translate the touches to
 */
- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame;

/**
 *  Synchronously dispatch the specified touches.  This will block as described in the delegate.
 *  This will specify the views bounds as the rect to translate the touches to.
 *
 *  @param touches An array of touch objects to dispatch
 *  @param view    The view to dispatch the touches in
 */
- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view;

/**
 *  Dispatch the touches and return immediately.   This API should be used with care as managing the timing
 *  of a lot of touch dispatches can be complicated.
 *
 *  @param touches An array of touch objects to dispatch
 *  @param view    The view to dispatch the touches in
 *  @param frame   The rect in the view to translate the touches to
 */
- (void)asynchronouslySimulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame;

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

@end

@protocol FRYTouchDispatchDelegate <NSObject>

- (void)touchDispatch:(FRYTouchDispatch *)touchDispatch willStartSimulationOfTouches:(NSArray *)touches;
- (void)touchDispatch:(FRYTouchDispatch *)touchDispatch didCompleteSimulationOfTouches:(NSArray *)touches;

@end
