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

static NSTimeInterval const kFRYRunLoopDefaultTimeout = 5.0;

@implementation NSRunLoop(FRY)

- (void)fry_waitForIdle;
{
    [self fry_waitForIdleWithTimeout:kFRYRunLoopDefaultTimeout];
}

- (void)fry_waitForIdleWithTimeout:(NSTimeInterval)timeout;
{
    [self fry_waitWithTimeout:timeout forCheck:^BOOL{
        return ([[FRYTouchDispatch shared] hasActiveTouches] == NO &&
                [[UIApplication sharedApplication] fry_animatingViewToWaitFor] == nil &&
                [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO);
    }];
}

- (void)fry_waitForCheck:(FRYCheckBlock)checkBlock;
{
    [self fry_waitWithTimeout:kFRYRunLoopDefaultTimeout forCheck:checkBlock];
}

- (void)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    while ( checkBlock() == NO &&
            start + timeout > [NSDate timeIntervalSinceReferenceDate] )
    {

        [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kFRYEventDispatchInterval]];
    }
    
    if ( [NSDate timeIntervalSinceReferenceDate] > start + timeout ) {
        NSLog(@"Spinning the run loop for more than %f seconds!", timeout);
    }
}

@end
