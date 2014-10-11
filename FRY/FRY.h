//
//  FRYToucher.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYDefines.h"
#import "FRYSimulatedTouch.h"
#import "NSObject+FRYLookupSupport.h"


@interface FRY : NSObject

+ (FRY *)shared;

/**
 * Simulate a touch with a series of points in time in the view.   This does not
 * cause any touch events to occur, those will occur when sendNextEvent is called.
 *
 * This can be called on any thread.
 */
- (void)simulateTouch:(FRYSimulatedTouch *)touch matchingView:(NSDictionary *)lookupVariables;
- (void)simulateTouch:(FRYSimulatedTouch *)touch matchingView:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow;
- (void)simulateTouches:(NSArray *)touches matchingView:(NSDictionary *)lookupVariables;
- (void)simulateTouches:(NSArray *)touches matchingView:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow;

- (void)findViewsMatching:(NSDictionary *)lookupVariables whenFound:(FRYInteractionBlock)foundBlock;
- (void)findViewsMatching:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow whenFound:(FRYInteractionBlock)foundBlock;

/**
 * Check to see if there are any active touches
 */
- (BOOL)hasActiveTouches;

/**
 * Check to see if there are any active interactions
 */
- (BOOL)hasActiveInteractions;

/**
 * Clear out any touches and lookups.  This will send cancel events for any active touches to ensure that
 * the application state doesn't get munged.
 */
- (void)clearInteractionsAndTouches;

@end


@interface FRY(Dispatch)

- (void)setMainThreadDispatchEnabled:(BOOL)enabled;

- (void)performAllLookups;

- (void)sendNextEvent;

@end