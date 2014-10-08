//
//  UIKit+Private.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct __GSEvent * GSEventRef;

@interface UIEvent (FRYExposePrivate)

- (void)_addTouch:(id)arg1 forDelayedDelivery:(BOOL)arg2;
- (void)_clearTouches;
- (void)_setGSEvent:(GSEventRef)event;

@end

@interface UIApplication (FRYExposePrivate)
- (UIEvent *)_touchesEvent;
@end

@interface NSObject (FRYExposePrivate)

- (void)tapInteractionWithLocation:(CGPoint)point;

@end

@interface FRYKBKey : NSObject

- (NSString *)representedString;
- (CGRect)frame;

@end

@interface FRYKBKeyplane : NSObject // UIKBKeyplane

- (BOOL)isShiftKeyplane;

- (NSArray *)keys;

@end

@interface FRYKBKeyplaneView : UIView // UIKBKeyplaneView

- (FRYKBKeyplane *)keyplane;
@end

