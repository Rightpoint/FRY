//
//  UIScrollView+FRYScrollingState.h
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This is a very, very ugly collection of hacks.  However, it is the only way to determine, with some accuracy
 *  if the scroll view is 'idle', without requiring the modification of application code.
 *
 *  This category swizzles internal methods and turns on a flag when a momentum animation starts, and stops.
 *  It also swizzles setContentOffset:animated: and wraps the call in an animation block that turns this
 *  animation flag on and off when driven via animated:YES.
 *
 *  This in combination with self.tracking and self.dragging provides a consistent state of when the scroll view
 *  is not idle.
 *
 *  Never do this in a shipping app.
 */
@interface UIScrollView(FRYScrollingState) <UIScrollViewDelegate>

+ (void)fry_swizzleProgramaticScrollDetection;

- (BOOL)fry_isScrolling;

@end
