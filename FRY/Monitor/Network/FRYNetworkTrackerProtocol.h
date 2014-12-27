//
//  FRYNetworkMonitorProtocol.h
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRYNetworkTrackerProtocol;

@protocol FRYNetworkTrackerProtocolDelegate <NSObject>

- (void)didStartLoading:(FRYNetworkTrackerProtocol *)monitor;
- (void)didStopLoading:(FRYNetworkTrackerProtocol *)monitor;

@end

@interface FRYNetworkTrackerProtocol : NSURLProtocol

+ (void)setNetworkMonitorDelegate:(id<FRYNetworkTrackerProtocolDelegate>)delegate;

@property (strong, nonatomic) NSURLConnection *connection;

@end
