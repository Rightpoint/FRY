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

NSTimeInterval const kFRYRunLoopSpinInterval = 0.05;


typedef void(^FRYRunLoopObserverBlock)(CFRunLoopObserverRef observer, CFRunLoopActivity activity);

@implementation NSRunLoop(FRY)

- (BOOL)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock;
{
    // Process any sources that have work pending, before checking the check block.
    // Often UIKit will have layout work to do, and this minimizes the error cases.
    while ( CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) == kCFRunLoopRunHandledSource ) {}

    // Spin the runloop, checking the check block any time the runloop reports
    // that something happened.
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
    NSTimeInterval remainingTimeout = [endDate timeIntervalSinceNow];
    BOOL ok = checkBlock();
    while( ok == NO && remainingTimeout > 0 ) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, remainingTimeout, true);
        ok = checkBlock();
        remainingTimeout = [endDate timeIntervalSinceNow];
    }
    return ok;
}

@end
