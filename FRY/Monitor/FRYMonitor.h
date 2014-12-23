//
//  FRYTouchMonitor.h
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYTouchTracker.h"
#import "FRYTouchHighlightWindowLayer.h"

@class FRYMonitor;

@protocol FRYMonitorDelegate <NSObject>

- (NSURL *)appSchemeURLRepresentingCurrentStateForMonitor:(FRYMonitor *)monitor;

@end

@interface FRYMonitor : NSObject

+ (FRYMonitor *)shared;

@property (strong, nonatomic) FRYTouchTracker *tracker;
@property (strong, nonatomic) FRYTouchHighlightWindowLayer *highlightLayer;

- (void)enable;
- (void)disable;

/**
 *  Add a gesture recognizer to the view to start recording when a 2 finger triple tap
 *  is detected.   Once the touch sequence occurs, the monitor will record touches  until the
 *  app resigns and becomes active again.   The gesture recognizer is disabled while recording.
 */
- (void)registerGestureEnablingOnView:(UIView *)view;

@end
