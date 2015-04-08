//
//  UIKit+Private.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct __GSEvent * GSEventRef;

@interface UIView (FRYExposePrivate)
- (void)_accessibilityElementsInContainer:(id)obj;
@end

@interface UIEvent (FRYExposePrivate)

- (id)_initWithEvent:(GSEventRef)event touches:(id)touches;
- (void)_addTouch:(id)arg1 forDelayedDelivery:(BOOL)arg2;
- (void)_clearTouches;
- (void)_setGSEvent:(GSEventRef)event;
- (GSEventRef)_gsEvent;

@end

@interface UIApplication (FRYExposePrivate)
- (BOOL)handleEvent:(GSEventRef)event withNewEvent:(id)newEvent;

- (UIEvent *)_touchesEvent;
- (id)_accessibilityBundlePrincipalClass;
- (BOOL)rotateIfNeeded:(UIDeviceOrientation)orientation;
- (void)rotateIfNeeded:(UIDeviceOrientation)orientation completion:(void (^)(void))completion;

@end

@interface UIScrollView (FRYExposePrivate)

-(void)_startTimer:(BOOL)timer;
-(void)_scrollViewDidEndDecelerating;

@end

@interface UIKeyboardTaskQueue : NSObject

- (void)waitUntilAllTasksAreFinished;

@end

@interface UIKeyboardImpl : NSObject
+ (UIKeyboardImpl *)sharedInstance;
- (void)addInputString:(NSString *)string;
- (void)deleteFromInput;
@property(getter=isInHardwareKeyboardMode) BOOL inHardwareKeyboardMode;
@property(retain) UIResponder<UIKeyInput> * delegate;
@property(readonly) UIKeyboardTaskQueue * taskQueue;
@end

@interface FRYPrivateSelectors : NSObject
- (void)_accessibilityStartServer;
@end
