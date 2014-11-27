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

typedef void(^FRYRunLoopObserverBlock)(CFRunLoopObserverRef observer, CFRunLoopActivity activity);

@implementation NSRunLoop(FRY)

- (BOOL)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock;
{
    // Spin the runloop for a tad, incase some action initiated a performSelector:withObject:afterDelay:
    // which will cause some state change very soon.
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    BOOL checkOK = checkBlock();
    while ( checkOK == NO
//           && start + timeout > [NSDate timeIntervalSinceReferenceDate]
           )
    {
        @autoreleasepool {
            [self runUntilDate:[NSDate dateWithTimeIntervalSinceNow:kFRYEventDispatchInterval]];
            checkOK = checkBlock();
        }
    }
    
    return checkOK;
}

@end
