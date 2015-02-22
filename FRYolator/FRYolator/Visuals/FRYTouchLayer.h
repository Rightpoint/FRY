//
//  FRYTouchLayer.h
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYTouchLayer : CALayer

- (void)setTouchColor:(CGColorRef)touchColor;

- (void)startAtPoint:(CGPoint)point;

- (void)moveToPoint:(CGPoint)point;

- (void)finishAtPoint:(CGPoint)point;

@end
