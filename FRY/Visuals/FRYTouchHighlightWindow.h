//
//  FRYTouchHighlightWindow.h
//  FRY
//
//  Created by Brian King on 11/19/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYTouchHighlightWindow : UIWindow

+ (void)enable;
+ (void)disable;
+ (FRYTouchHighlightWindow *)touchHighlightWindow;

@property (assign, nonatomic) BOOL highlightViewFrames;

@property (strong, nonatomic) UIColor *touchColor;
@property (strong, nonatomic) UIColor *frameBorderColor;

@end
