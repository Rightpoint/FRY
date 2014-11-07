//
//  NSRunloop+FRY.h
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYDefines.h"

@interface NSRunLoop(FRY)

/**
 * Wait until all animations are complete, all touches have been dispatched, and user interaction is enabled.
 */
- (void)fry_waitForIdle;
- (void)fry_waitForIdleWithTimeout:(NSTimeInterval)timeout;

- (void)fry_waitForCheck:(FRYCheckBlock)checkBlock withFailureExplaination:(FRYCheckFailureExplaination)failureExplaination;
- (void)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock withFailureExplaination:(FRYCheckFailureExplaination)failureExplaination;

@end
