//
//  FRYTouchMonitor.h
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for FRYolator.
FOUNDATION_EXPORT double FRYolatorVersionNumber;

//! Project version string for FRYolator.
FOUNDATION_EXPORT const unsigned char FRYolatorVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <FRYolator/PublicHeader.h>

#import "FRYTouchTracker.h"
#import "FRYTouchHighlightWindowLayer.h"

@class FRYolator;

@protocol FRYolatorDelegate <NSObject>
@optional

/**
 *  When the FRYolator begins recording, it will ask the delegate for an in-app URL to represent
 *  this location.   It can use this information to assist in re-creating application state later.
 */
- (NSURL *)appSchemeURLRepresentingCurrentStateForFryolator:(FRYolator *)monitor;

/**
 *  Returns an array of keypaths to match for the URL Request
 */
- (NSString *)fryolator:(FRYolator *)fryolator filenamePrefixForRequest:(NSURLRequest *)request;

@end

@interface FRYolator : NSObject

+ (FRYolator *)shared;

@property (strong, nonatomic, readonly) FRYTouchTracker *touchTracker;
@property (strong, nonatomic, readonly) FRYTouchHighlightWindowLayer *highlightLayer;
@property (assign, nonatomic) id<FRYolatorDelegate>delegate;

- (void)enable;
- (void)disable;

/**
 *  Add a gesture recognizer to the view to start recording when a 2 finger triple tap
 *  is detected.   Once the touch sequence occurs, the monitor will record touches  until the
 *  app resigns and becomes active again.   The gesture recognizer is disabled while recording.
 */
- (void)registerGestureEnablingOnView:(UIView *)view;

@end
