//
//  FRYIdleOperationQueueCheck.m
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYIdleOperationQueueCheck.h"

@implementation FRYIdleOperationQueueCheck

- (instancetype)initWithOperationQueue:(NSOperationQueue *)operationQueue
{
    self = [super init];
    if ( self ) {
        _operationQueue = operationQueue;
    }
    return self;
}

- (BOOL)isIdle
{
    return self.operationQueue.operationCount == 0;
}

- (NSString *)busyDescription
{
    return [NSString stringWithFormat:@"%zd operations remaining:\n%@",
            self.operationQueue.operationCount,
            self.operationQueue.operations];
}

@end
