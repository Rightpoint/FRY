//
//  UIApplication+FRY.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYDefines.h"
#import "FRYTypist.h"

@interface UIApplication(FRY)

/**
 * Helper method for generating a UITouch event
 */
- (UIEvent *)fry_eventWithTouches:(NSArray *)touches;

/**
 *  Return windows and the keyWindow. keyWindow is not always in the windows array.
 */
- (NSArray *)fry_allWindows;

/**
 * Return the first view that is a subview of fry_inputViewWindow matching cls.
 */
- (UIView *)fry_inputViewOfClass:(Class)cls;

@end
