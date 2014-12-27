//
//  FRYNetworkTracker.m
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYNetworkTracker.h"
#import "FRYNetworkTrackerProtocol.h"

@interface FRYNetworkTracker() <FRYNetworkTrackerProtocolDelegate>

@end

@implementation FRYNetworkTracker


- (void)enable
{
    [super enable];
    [FRYNetworkTrackerProtocol setNetworkMonitorDelegate:self];
}

- (void)disable
{
    [super disable];
    [FRYNetworkTrackerProtocol setNetworkMonitorDelegate:nil];
}

@end
