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

@end
