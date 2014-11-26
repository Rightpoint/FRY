//
//  FRYTouchDispatchedCheck.m
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchDispatchedCheck.h"
#import "FRYTouchDispatch.h"

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
    return [NSString stringWithFormat:@"Still have active touches: %@\n", [FRYTouchDispatch shared]];
}

@end

