//
//  FRYIdleCheck.h
//  FRY
//
//  Created by Brian King on 11/17/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRYIdleCheck;

@protocol FRYIdleCheckDelegate <NSObject>

@optional

- (BOOL)isApplicationIdle:(FRYIdleCheck *)idleCheck;
- (NSString *)applicationBusyDescriptionWithIdle:(FRYIdleCheck *)idleCheck;
- (NSArray *)viewsToIgnoreForAnimationComplete:(FRYIdleCheck *)idleCheck;

@end

/**
 *  Idle checks are a helper concept to aide in the flow control of the unit tests, and reduce all asynchronous operations down to a boolean.
 *
 *  By default, the system will wait for:
 *
 *  ```
 *  [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO
 *  [[UIApplication sharedApplication] fry_allChildrenViewsMatching:[NSPredicate fry_animatingView]].count == 0
 *  [[FRYTouchDispatch shared] hasActiveTouches] == NO
 *  ```
 *
 *  More idle checks can be if your application requires it. A proper UI design, theoretically should not require any modifications, as a UI element should be animating at all times if the system is not idle. Use the delegate pattern to add idle checks, like ensuring that a network NSOperationQueue.
 *
 *
 *  Also, some times you do not want certain view animations to block your tests. If that's the case, return the views you want to ignore via the delegate pattern.
 *
 *  The delegate pattern also provides a method to return a description of why your application is not idle. This can help provide robust error messages.
 */
@interface FRYIdleCheck : NSObject

+ (FRYIdleCheck *)system;

@property (weak, nonatomic) id<FRYIdleCheckDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval timeout;

- (BOOL)isIdle;

- (NSString *)busyDescription;

- (BOOL)waitForIdle;

@end
