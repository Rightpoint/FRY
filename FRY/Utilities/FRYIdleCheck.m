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

static NSTimeInterval const kFRYIdleCheckDefaultTimeout = 5.0;
static FRYIdleCheck *systemIdleCheck = nil;

@interface FRYIdleCheck()

@property (strong, nonatomic) NSMutableSet *ignorePredicates;

@end

@implementation FRYIdleCheck

+ (FRYIdleCheck *)system
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"%@ is not thread safe, call on main thread only", self.class);
    if ( systemIdleCheck == nil ) {
        systemIdleCheck = [[FRYIdleCheck alloc] init];
    }
    return systemIdleCheck;
}

+ (void)setSystemIdleCheck:(FRYIdleCheck *)idleCheck
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"%@ is not thread safe, call on main thread only", self.class);
    systemIdleCheck = idleCheck;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.ignorePredicates = [NSMutableSet set];
    }
    return self;
}

- (BOOL)isIdle
{
    return ([[FRYTouchDispatch shared] hasActiveTouches] == NO &&
            [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO &&
            [self animatingViews].count == 0);
}

- (NSString *)busyDescription
{
    return [NSString stringWithFormat:@"%@%@%@",
            [[FRYTouchDispatch shared] hasActiveTouches] ? @"Still have active touches\n" : @"",
            [[UIApplication sharedApplication] isIgnoringInteractionEvents] ? @"UIApplication is ignoring interaction events\n" : @"",
            [self animatingViews].count != 0 ? [NSString stringWithFormat:@"%@ are still animating", [self animatingViews]] : @""];
}

- (NSTimeInterval)defaultTimeoutForRunloop
{
    return [[FRYTouchDispatch shared] maxTouchDuration] + kFRYIdleCheckDefaultTimeout;
}

- (BOOL)waitForIdle
{
    BOOL isIdle = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:[self defaultTimeoutForRunloop]
                                                         forCheck:^BOOL{
                                                             return [self isIdle];
                                                         }];
    if ( isIdle == NO ) {
        NSLog(@"%@", [self busyDescription]);
    }
    return isIdle;
}

- (NSArray *)animatingViews
{
    NSArray *views = [[UIApplication sharedApplication] fry_animatingViews];
    for ( NSPredicate *predicate in self.ignorePredicates ) {
        views = [views filteredArrayUsingPredicate:[NSCompoundPredicate notPredicateWithSubpredicate:predicate]];
    }
    return views;
}

- (void)ignoreAnimationsOnViewsMatching:(NSPredicate *)predicate;
{
    [self.ignorePredicates addObject:predicate];
}

@end
