//
//  NSRunloop+FRY.h
//  FRY
//
//  Created by Brian King on 10/11/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^FRYCheckBlock)();

@interface NSRunLoop(FRY)

/**
 * Wait for the condition to be true with the specified timeout.
 *
 * This method returns YES if the check passed before the timeout interval.
 */
- (BOOL)fry_waitWithTimeout:(NSTimeInterval)timeout forCheck:(FRYCheckBlock)checkBlock;

- (void)fry_handleSources;

@end
