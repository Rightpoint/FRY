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
    FRYRunLoopObserverBlock before = ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {

        if ( checkBlock() ) {
            CFRunLoopStop([self getCFRunLoop]);
        }
        else {
            CFRunLoopWakeUp([self getCFRunLoop]);
        }
    };

    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, true, 0, before);
    CFRunLoopAddObserver([self getCFRunLoop], observer, kCFRunLoopDefaultMode);

    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];

    CFRunLoopRunInMode(kCFRunLoopDefaultMode, timeout, false);
    
    CFRunLoopRemoveObserver([self getCFRunLoop], observer, kCFRunLoopDefaultMode);
    CFRelease(observer);

    return start + timeout > [NSDate timeIntervalSinceReferenceDate];
}

@end
