//
//  FRYHighlightView.h
//  FRY
//
//  Created by Rob Visentin on 11/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

@interface FRYHighlightView : UIView

@property (assign, nonatomic) CGFloat pointSize;

@property (assign, nonatomic) BOOL showingFrame;
- (void)setShowingFrame:(BOOL)showingFrame animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@property (assign, nonatomic, readonly) BOOL showingPoint;

- (void)highlightPoint:(CGPoint)point animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;
- (void)unhighlightPointAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
