//
//  FRYIdleOperationQueueCheck.h
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYIdleCheck.h"

@interface FRYIdleOperationQueueCheck : FRYIdleCheck

- (instancetype)initWithOperationQueue:(NSOperationQueue *)operationQueue;

@property (strong, nonatomic, readonly) NSOperationQueue *operationQueue;

@end
