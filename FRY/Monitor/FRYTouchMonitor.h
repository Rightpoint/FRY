//
//  FRYTouchMonitor.h
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYTouchRecorder.h"
#import "FRYTouchHighlightWindowLayer.h"

@interface FRYTouchMonitor : NSObject

+ (FRYTouchMonitor *)shared;

@property (strong, nonatomic) FRYTouchRecorder *recorder;
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
