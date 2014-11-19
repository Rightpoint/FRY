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


@implementation NSRunLoop(FRY)

- (BOOL)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock;
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    while ( checkBlock() == NO &&
            start + timeout > [NSDate timeIntervalSinceReferenceDate] )
    {
        [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kFRYEventDispatchInterval]];
    }
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.05]];
    return start + timeout > [NSDate timeIntervalSinceReferenceDate];
}

@end
