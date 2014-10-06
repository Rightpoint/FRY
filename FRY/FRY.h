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
 * Simulate a touch with a series of points in time in the view.
 * This method can be called on any thread.
 */
- (void)simulateTouchDefinition:(FRYTouchDefinition *)touchDefinition inView:(UIView *)view;

/**
 * Conviencence function for simulating multi-touch events returned from FRYTouchDefinition construnctors
 */
- (void)simulateTouchDefinitions:(NSArray *)touchDefinitions inView:(UIView *)view;

/**
 * Specify a lookup to perform.
 */
- (void)addLookup:(FRYLookup *)lookup;

/**
 * Checks to see if there are any active touches
 */
- (BOOL)hasActiveTouches;

/**
 * Checks to see if there are any active lookups
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

@end