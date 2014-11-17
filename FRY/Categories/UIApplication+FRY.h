//
//  UIApplication+FRY.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYDefines.h"
#import "UIKit+FRYExposePrivate.h"
#import "FRYTypist.h"

@interface UIApplication(FRY)

/**
 * Helper method for generating a UITouch event
 */
- (UIEvent *)fry_eventWithTouches:(NSArray *)touches;

/**
 *  Return all animating views in all windows.
 */
- (NSArray *)fry_animatingViews;

/**
 * Return the first of the animating views to wait for.
 * This API should be deprecated!
 */
- (UIView *)fry_animatingViewToWaitFor;

/**
 *  Return a helper typing object.
 */
- (FRYTypist *)fry_typist;

/**
 * Return the window that incapsulates input views
 */
- (UIWindow *)fry_inputViewWindow;

/**
 *  Return windows and the keyWindow.   keyWindow is not always in the windows array.
 */
- (NSArray *)fry_allWindows;

/**
 * Return the first view that is a subview of fry_inputViewWindow matching klass.
 */
- (UIView *)fry_inputViewOfClass:(Class)klass;

@end
