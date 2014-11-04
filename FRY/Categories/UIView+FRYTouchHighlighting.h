//
//  UIView+FRYTouchHighlighting.h
//  FRY
//
//  Created by Rob Visentin on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

@interface UIView (FryTouchHighlighting)

- (void)fry_setFrameHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)fry_highlightPoint:(CGPoint)point animated:(BOOL)animated;

@end

