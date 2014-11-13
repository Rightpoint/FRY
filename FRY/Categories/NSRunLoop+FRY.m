//
//  NSRunloop+FRY.m
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSRunloop+FRY.h"
#import "FRYTouchDispatch.h"
#import "UIApplication+FRY.h"
#import "FRYDefines.h"

static NSTimeInterval const kFRYRunLoopDefaultTimeout = 5.0;

@implementation NSRunLoop(FRY)

- (void)fry_waitForIdle
{
    [self fry_waitForIdleWithTimeout:kFRYRunLoopDefaultTimeout];
}

- (void)fry_waitForIdleWithTimeout:(NSTimeInterval)timeout
{
    [self fry_waitWithTimeout:timeout forCheck:^BOOL{
        return ([[FRYTouchDispatch shared] hasActiveTouches] == NO &&
                [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO &&
                [[UIApplication sharedApplication] fry_animatingViewToWaitFor] == nil
                );
    } withFailureExplaination:^NSString *{
        UIView *animatingView = [[UIApplication sharedApplication] fry_animatingViewToWaitFor];
        return [NSString stringWithFormat:@"%@%@%@",
                [[FRYTouchDispatch shared] hasActiveTouches] ? @"Still have active touches\n" : @"",
                [[UIApplication sharedApplication] isIgnoringInteractionEvents] ? @"UIApplication is ignoring interaction events\n" : @"",
                animatingView != nil ? [NSString stringWithFormat:@"%@ is still animating", animatingView] : @""];
    }];
}

- (void)fry_waitForCheck:(FRYCheckBlock)checkBlock withFailureExplaination:(FRYCheckFailureExplaination)failureExplaination
{
    [self fry_waitWithTimeout:kFRYRunLoopDefaultTimeout forCheck:checkBlock withFailureExplaination:nil];
}

- (void)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock withFailureExplaination:(FRYCheckFailureExplaination)failureExplaination
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    while ( checkBlock() == NO &&
            start + timeout > [NSDate timeIntervalSinceReferenceDate] )
    {

        [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kFRYEventDispatchInterval]];
    }
    
    if ( [NSDate timeIntervalSinceReferenceDate] > start + timeout ) {
        [NSException raise:kFRYCheckFailedExcetion format:@"Check Failed: %@", failureExplaination()];
    }
    else {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    }
}

@end
