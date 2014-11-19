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


#import "FRYCompoundCheck.h"
#import "FRYAnimationCompleteCheck.h"
#import "FRYInteractionsEnabledCheck.h"
#import "FRYTouchDispatchedCheck.h"

static NSTimeInterval const kFRYIdleCheckDefaultTimeout = 5.0;
static FRYIdleCheck *systemIdleCheck = nil;


@implementation FRYIdleCheck

+ (FRYIdleCheck *)system
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"%@ is not thread safe, call on main thread only", self.class);
    if ( systemIdleCheck == nil ) {
        [self setupSystemChecks:@[[[FRYAnimationCompleteCheck alloc] init],
                                  [[FRYInteractionsEnabledCheck alloc] init],
                                  [[FRYTouchDispatchedCheck alloc] init]
                                  ]];
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
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
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
