//
//  NSRunloop+FRY.m
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSRunloop+FRY.h"
#import "FRY.h"

@implementation NSRunLoop(FRY)

- (void)fry_runUntilEventsLookupsAndAnimationsAreComplete
{
    [self fry_runUntilEventsLookupsAndAnimationsAreCompleteWithTimeout:5];
}

- (void)fry_runUntilEventsLookupsAndAnimationsAreCompleteWithTimeout:(NSTimeInterval)timeout
{
    while ( [[FRY shared] hasActiveTouches] ||
            [[FRY shared] hasActiveInteractions] ||
            [[FRY shared] hasAnimationToWaitForInTargetWindow:FRYTargetWindowAll] )
    {
        [[FRY shared] performAllLookups];
        [[FRY shared] sendNextEvent];
        [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kFRYEventDispatchInterval]];
    }
}
@end
