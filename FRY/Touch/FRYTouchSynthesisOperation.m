//
//  TouchDispatch.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchSynthesisOperation.h"
#import "FRYTouchInteraction.h"

@interface FRYTouchSynthesisOperation()

@end

@implementation FRYTouchSynthesisOperation

+ (FRYTouchSynthesisOperation *)shared
{
    static FRYTouchSynthesisOperation *dispatchOperation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatchOperation = [[FRYTouchSynthesisOperation alloc] init];
    });
    return dispatchOperation;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        self.toucher = [[FRYToucher alloc] init];
        self.queuePriority = NSOperationQueuePriorityVeryLow;
    }
    return self;
}

- (void)main
{
    while ( !self.isCancelled ) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.toucher sendNextEvent];
        });
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:self.minimumEventDelay]];
    }
}

@end
