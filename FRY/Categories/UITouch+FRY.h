//
//  UITouch+FRY.h
//  FRY
//
//  Created by Brian King on 10/4/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITouch (FRY)

- (id)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window;

- (void)setLocationInWindow:(CGPoint)location;
- (void)setPhaseAndUpdateTimestamp:(UITouchPhase)phase;

- (CGPoint)fry_locationRelativeToView;

/**
 * The view where the touch began can be nil'd out.   Hold on to the view.
 */
@property(strong, nonatomic) UIView *fry_viewWhereTouchBegan;

@end
