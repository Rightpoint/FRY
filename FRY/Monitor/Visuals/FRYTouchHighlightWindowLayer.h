//
//  FRYTouchHighlightWindow.h
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This window layer is a layer that will stick on top of all UIWindow.layer superlayer.
 * This is done rather than a custom UIWindow subclass to ensure that event handling is
 * never disturbed.
 */
@interface FRYTouchHighlightWindowLayer : CALayer

- (void)enable;
- (void)disable;

@property (assign, nonatomic) BOOL highlightViewFrames;

@property (strong, nonatomic) UIColor *touchColor;
@property (strong, nonatomic) UIColor *frameBorderColor;

- (void)visualizeEvent:(UIEvent *)event;

@end
