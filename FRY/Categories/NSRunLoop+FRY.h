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

- (void)fry_waitForIdle;
- (void)fry_waitForIdleWithTimeout:(NSTimeInterval)timeout;

- (void)fry_waitForCheck:(FRYCheckBlock)checkBlock;
- (void)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock;

@end
