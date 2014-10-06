//
//  FRYToucher.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYTouchDefinition.h"
#import "FRYLookup.h"

@interface FRY : NSObject

+ (FRY *)shared;

/**
 * Simulate a touch with a series of points in time in the view.   This does not
 * cause any touch events to occur, those will occur when sendNextEvent is called.
 *
 * This can be called on any thread.
 * FIXME: This has a view object, so can only really be called on main thread.   Should really expose FRYTargetWindow
 */
- (void)addTouchWithDefinition:(FRYTouchDefinition *)touchDefinition inView:(UIView *)view;

/**
 * Conviencence function for simulating multi-touch events returned from FRYTouchDefinition construnctors
 */
- (void)addTouchWithDefinitions:(NSArray *)touchDefinitions inView:(UIView *)view;

/**
 * Specify a lookup to perform.  This can be called from any thread
 */
- (void)addLookup:(FRYLookup *)lookup;

/**
 * Check to see if there are any active touches
 */
- (BOOL)hasActiveTouches;

/**
 * Check to see if there are any active lookups
 */
- (BOOL)hasActiveLookups;

/**
 * Clear out any touches and lookups.  This will send cancel events for any active touches to ensure that
 * the application state doesn't get munged.
 */
- (void)clearLookupsAndTouches;

@end


@interface FRY(Dispatch)

- (void)setMainThreadDispatchEnabled:(BOOL)enabled;

- (void)performAllLookups;

- (void)sendNextEvent;

@end