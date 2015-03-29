//
//  FRYolatorUI.h
//  FRYolator
//
//  Created by Brian King on 3/2/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYolatorUI : NSObject

+ (FRYolatorUI *)shared;

/**
 *  Add a gesture recognizer to the view to start recording when a 2 finger triple tap
 *  is detected.   Once the touch sequence occurs, the monitor will record touches  until the
 *  sequence occurs again.
 */
- (void)registerGestureEnablingOnView:(UIView *)view;

@end
