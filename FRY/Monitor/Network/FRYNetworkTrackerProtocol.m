//
//  FRYNetworkMonitorProtocol.m
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYNetworkTrackerProtocol.h"

static NSString* const FRYNetworkRequestTrackedHeader = @"X-FRY-Track";

static id<FRYNetworkTrackerProtocolDelegate> s_delegate = nil;

@interface FRYNetworkTrackerProtocol() <NSURLConnectionDataDelegate>

@end

@implementation FRYNetworkTrackerProtocol

+ (void)setNetworkMonitorDelegate:(id<FRYNetworkTrackerProtocolDelegate>)delegate;
{
    // Need to cancel out / assert on nil if there are active requests.
    s_delegate = delegate;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *scheme = [[request URL] scheme];
    BOOL isHTTP = [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"];
    return s_delegate && isHTTP && [request valueForHTTPHeaderField:FRYNetworkRequestTrackedHeader] == nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request
       cachedResponse:(NSCachedURLResponse *)cachedResponse
               client:(id <NSURLProtocolClient>)client
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:@"" forHTTPHeaderField:FRYNetworkRequestTrackedHeader];
    
    self = [super initWithRequest:mutableRequest
                   cachedResponse:cachedResponse
                           client:client];
    
    return self;
}

- (void)startLoading
{
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request
                                                      delegate:self
                                              startImmediately:YES];
    [s_delegate didStartLoading:self];
}

- (void)stopLoading
{
    [s_delegate didStopLoading:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageAllowed];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    return request;
}

- (NSInputStream *)connection:(NSURLConnection *)connection needNewBodyStream:(NSURLRequest *)request
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

@end
