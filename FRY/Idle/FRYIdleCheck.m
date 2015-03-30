//
//  FRYIdleCheck.m
//  FRY
//
//  Created by Brian King on 11/17/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYIdleCheck.h"
#import "FRYTouchDispatch.h"
#import "UIApplication+FRY.h"
#import "NSRunLoop+FRY.h"
#import "NSObject+FRYLookup.h"
#import "NSPredicate+FRY.h"
#import "UIApplication+FRY.h"
#import "UIView+FRY.h"
static FRYIdleCheck *systemIdleCheck = nil;

@interface FRYIdleCheck () <FRYTouchDispatchDelegate>

@end

@implementation FRYIdleCheck

+ (void)load
{
    // Take over the delegate of the touch dispatch if nil.
    if ( [FRYTouchDispatch shared].delegate == nil ) {
        [FRYTouchDispatch shared].delegate = [self system];
    }
}

+ (FRYIdleCheck *)system
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"%@ is not thread safe, call on main thread only", self.class);
    if ( systemIdleCheck == nil ) {
        systemIdleCheck = [[FRYIdleCheck alloc] init];
    }
    return systemIdleCheck;
}


- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.timeout = 5.0;
    }
    return self;
}

- (BOOL)isIdle
{
    return ([self interactionIsComplete] &&
            [self animationIsComplete] &&
            [self touchingIsComplete] &&
            [self delegateIsComplete]);
}

- (NSString *)busyDescription
{
    NSMutableString *description = [NSMutableString string];
    if ( [self interactionIsComplete] == NO ) {
        [description appendFormat:@"%@\n", [self interactionBusyDescription]];
    }
    if ( [self animationIsComplete] == NO ) {
        [description appendFormat:@"%@\n", [self animationActiveDescription]];
    }
    if ( [self touchingIsComplete] == NO ) {
        [description appendFormat:@"%@\n", [self touchActiveDescription]];
    }
    if ( [self delegateIsComplete] == NO ) {
        [description appendFormat:@"%@\n", [self delegateActiveDescription]];
    }
    return [description copy];
}

- (BOOL)delegateIsComplete
{
    if ( self.delegate == nil || [self.delegate respondsToSelector:@selector(isApplicationIdle:)] == NO ) {
        return YES;
    }
    return [self.delegate isApplicationIdle:self];
}

- (NSString *)delegateActiveDescription
{
    if ( self.delegate == nil || [self.delegate respondsToSelector:@selector(applicationBusyDescriptionWithIdle:)] == NO ) {
        return @"Unknown";
    }
    return [self.delegate applicationBusyDescriptionWithIdle:self];
}

#pragma mark - Interaction

- (BOOL)interactionIsComplete
{
    return [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO;
}

- (NSString *)interactionBusyDescription
{
    return @"UIApplication is ignoring interaction events";
}

#pragma mark - Animation

- (BOOL)animationIsComplete
{
    return [self animatingViews].count == 0;
}

- (NSString *)animationActiveDescription
{
    return [NSString stringWithFormat:@"%@ are still animating", [self animatingViews]];
}

- (NSArray *)animatingViews
{
    NSSet *elements = [[UIApplication sharedApplication] fry_allChildrenMatching:[NSPredicate fry_animatingView]];
    
    NSMutableArray *views = [[elements valueForKey:FRY_KEYPATH(UIView, fry_representingView)] mutableCopy];
    if ( self.delegate && [self.delegate respondsToSelector:@selector(viewsToIgnoreForAnimationComplete:)] ) {
        NSArray *ignoreViews = [self.delegate viewsToIgnoreForAnimationComplete:self];
        for ( UIView *v in [ignoreViews copy] ) {
            NSSet *elements = [v fry_allChildrenMatching:[NSPredicate fry_animatingView]];
            NSSet *subAnimatingViews = [elements valueForKey:FRY_KEYPATH(UIView, fry_representingView)];
            ignoreViews = [ignoreViews arrayByAddingObjectsFromArray:[subAnimatingViews allObjects]];
        }
        [views removeObjectsInArray:ignoreViews];
    }
    return [views copy];
}

#pragma mark - Touch Dispatch

- (BOOL)touchingIsComplete
{
    return [[FRYTouchDispatch shared] hasActiveTouches] == NO;
}

- (NSString *)touchActiveDescription
{
    return [NSString stringWithFormat:@"Still have active touches: %@\n", [FRYTouchDispatch shared]];
}

- (BOOL)waitForIdle
{
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.1]];
    NSTimeInterval timeout = [[FRYTouchDispatch shared] maxTouchDuration] + self.timeout;
    BOOL isIdle = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:timeout
                                                         forCheck:^BOOL{
                                                             return [self isIdle];
                                                         }];
    if ( isIdle == NO ) {
        NSLog(@"%@", [self busyDescription]);
    }
    return NO;
}

#pragma mark - Touch Dispatch Delegate

- (void)touchDispatch:(FRYTouchDispatch *)touchDispatch willStartSimulationOfTouches:(NSArray *)touches
{
    [self waitForIdle];
}

- (void)touchDispatch:(FRYTouchDispatch *)touchDispatch didCompleteSimulationOfTouches:(NSArray *)touches
{
    [self waitForIdle];
}

@end
