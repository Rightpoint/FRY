//
//  FRYNetworkMonitorProtocol.h
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRYNetworkTrackerProtocol;
@class FRYNetworkEvent;

@protocol FRYNetworkTrackerProtocolDelegate <NSObject>

- (void)networkTrackerProtocol:(FRYNetworkTrackerProtocol *)monitor didStartEvent:(FRYNetworkEvent *)event;
- (void)networkTrackerProtocol:(FRYNetworkTrackerProtocol *)monitor didCompleteEvent:(FRYNetworkEvent *)event;

@end

@interface FRYNetworkTrackerProtocol : NSURLProtocol

+ (void)setNetworkMonitorDelegate:(id<FRYNetworkTrackerProtocolDelegate>)delegate;

@property (strong, nonatomic) NSURLConnection *connection;

@end
