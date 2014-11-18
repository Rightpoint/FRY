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


@implementation FRYIdleCheck

+ (FRYIdleCheck *)system
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"%@ is not thread safe, call on main thread only", self.class);
    if ( systemIdleCheck == nil ) {
        NSArray *checks = @[[[FRYAnimationCompleteCheck alloc] init],
                            [[FRYInteractionsEnabledCheck alloc] init],
                            [[FRYTouchDispatchedCheck alloc] init]
                            ];

        systemIdleCheck = [[FRYCompoundCheck alloc] initWithChecks:checks];
    }
    return systemIdleCheck;
}

+ (void)setupSystemChecks:(NSArray *)checks
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"%@ is not thread safe, call on main thread only", self.class);
    systemIdleCheck = [[FRYCompoundCheck alloc] initWithChecks:checks];
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.timeout = kFRYIdleCheckDefaultTimeout;
    }
    return self;
}

- (BOOL)isIdle
{
    return YES;
}

- (NSString *)busyDescription
{
    return @"";
}

- (NSTimeInterval)defaultTimeoutForRunloop
{
    return kFRYIdleCheckDefaultTimeout;
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

@end


@implementation FRYTouchDispatchedCheck : FRYIdleCheck

- (BOOL)isIdle
{
    return [[FRYTouchDispatch shared] hasActiveTouches] == NO;
}

- (NSTimeInterval)timeout
{
    return [[FRYTouchDispatch shared] maxTouchDuration] + super.timeout;
}

- (NSString *)busyDescription
{
    return @"Still have active touches\n";
}

@end

@interface FRYAnimationCompleteCheck()

@property (strong, nonatomic) NSMutableSet *ignorePredicates;

@end

@implementation FRYAnimationCompleteCheck : FRYIdleCheck

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
    return [self animatingViews].count == 0;
}

- (NSString *)busyDescription
{
    return [NSString stringWithFormat:@"%@ are still animating", [self animatingViews]];
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

@implementation FRYInteractionsEnabledCheck : FRYIdleCheck

- (BOOL)isIdle
{
    return [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO;
}

- (NSString *)busyDescription
{
    return @"UIApplication is ignoring interaction events";
}

@end

@implementation FRYCompoundCheck : FRYIdleCheck

- (instancetype)initWithChecks:(NSArray *)checks;
{
    self = [super init];
    if ( self ) {
        _checks = checks;
    }
    return self;
}

- (BOOL)isIdle
{
    BOOL isIdle = YES;
    for ( FRYIdleCheck *check in self.checks ) {
        if ( [check isIdle] == NO ) {
            isIdle = NO;
        }
    }
    return isIdle;
}

- (NSString *)busyDescription
{
    NSMutableString *busyDescription = [NSMutableString string];
    for ( FRYIdleCheck *check in self.checks ) {
        if ( [check isIdle] == NO ) {
            [busyDescription appendString:[check busyDescription]];
        }
    }
    return [busyDescription copy];
}

@end

