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

- (void)fry_runUntilEventsLookupsAndAnimationsAreComplete
{
    [self fry_runUntilEventsLookupsAndAnimationsAreCompleteWithTimeout:kFRYRunLoopDefaultTimeout];
}

- (void)fry_runUntilEventsLookupsAndAnimationsAreCompleteWithTimeout:(NSTimeInterval)timeout
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    while ( ([[FRY shared] hasActiveTouches] ||
             [[FRY shared] hasActiveInteractions] ||
             [[FRY shared] animatingViewToWaitForInTargetWindow:FRYTargetWindowAll]) &&
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
