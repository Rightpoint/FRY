//
//  FRYNetworkTracker.m
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYNetworkTracker.h"
#import "FRYNetworkTrackerProtocol.h"
#import "FRYNetworkEvent.h"

@interface FRYNetworkTracker() <FRYNetworkTrackerProtocolDelegate>

@end

@implementation FRYNetworkTracker


- (void)enable
{
    [super enable];
    [NSURLProtocol registerClass:[FRYNetworkTrackerProtocol class]];
    [FRYNetworkTrackerProtocol setNetworkMonitorDelegate:self];
}

- (void)disable
{
    [super disable];
    [FRYNetworkTrackerProtocol setNetworkMonitorDelegate:nil];
    [NSURLProtocol unregisterClass:[FRYNetworkTrackerProtocol class]];
}

- (void)networkTrackerProtocol:(FRYNetworkTrackerProtocol *)monitor didStartEvent:(FRYNetworkEvent *)event
{
}

- (void)networkTrackerProtocol:(FRYNetworkTrackerProtocol *)monitor didCompleteEvent:(FRYNetworkEvent *)event
{
    [self.delegate tracker:self recordEvent:event];
}

@end
