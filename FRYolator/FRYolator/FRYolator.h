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

#import "FRYolatorUI.h"
#import "FRYTouchTracker.h"
#import "FRYTouchHighlightWindowLayer.h"

@class FRYolator;

@protocol FRYolatorDelegate <NSObject>
@optional

/**
 *  When the FRYolator begins recording, it will ask the delegate for an in-app URL to represent
 *  this location. It can use this information to assist in re-creating application state later.
 */
- (NSURL *)appSchemeURLRepresentingCurrentStateForFryolator:(FRYolator *)monitor;

@end

/**
 *  FRY can be enabled by setting the following keypath to @(YES) in `NSUserDefaults.standardUserDefaults`
 *  FRYolator will observe changes to that value and enable and disable in response to this.   This
 *  is helpful for recording startup events.
 */
OBJC_EXTERN NSString *FRYolatorEnabledUserPreferencesKeyPath;

@interface FRYolator : NSObject

+ (FRYolator *)shared;

@property (strong, nonatomic, readonly) FRYTouchTracker *touchTracker;
@property (assign, nonatomic) id<FRYolatorDelegate>delegate;

- (void)enable;
- (void)disable;

@property (assign, nonatomic, readonly) BOOL enabled;

- (void)clearEventLog;

- (BOOL)saveEventLogNamed:(NSString *)eventLogName error:(NSError **)error;

@end
