//
//  NSRunloop+FRY.m
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSRunloop+FRY.h"
#import "FRY.h"


static NSTimeInterval const kFRYRunLoopDefaultTimeout = 5.0;

@implementation NSRunLoop(FRY)

- (void)fry_waitForIdle;
{
    [self fry_waitForIdleWithTimeout:kFRYRunLoopDefaultTimeout];
}

- (void)fry_waitForIdleWithTimeout:(NSTimeInterval)timeout;
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    while ( ([[FRY shared] hasActiveTouches] ||
             [[FRY shared] hasActiveInteractions] ||
             [[UIApplication sharedApplication] fry_animatingViewToWaitFor]) &&
           start + timeout > [NSDate timeIntervalSinceReferenceDate] )
    {
        [[FRY shared] performAllLookups];
        [[FRY shared] sendNextEvent];
        [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kFRYEventDispatchInterval]];
    }
    
    if ( [NSDate timeIntervalSinceReferenceDate] > start + timeout ) {
        NSLog(@"Spinning the run loop for more than %f seconds!", timeout);
    }
}
@end
