//
//  FRYToucher.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYDefines.h"
#import "FRYSyntheticTouch.h"
#import "NSObject+FRYLookupSupport.h"
#import "FRYLookupResult.h"
#import "FRYRecordedTouch.h"
#import "NSRunLoop+FRY.h"
#import "UIView+FRY.h"
#import "UIApplication+FRY.h"


@interface FRY : NSObject

+ (FRY *)shared;


- (void)addLookupCheck:(FRYCheckBlock)check;

- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame;


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

- (void)setMainThreadDispatchEnabled:(BOOL)enabled;

- (void)performAllLookups;

- (void)sendNextEvent;

@end