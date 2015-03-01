//
//  FRYNetworkEvent.m
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYNetworkEvent.h"

@interface FRYNetworkEvent()

@end

@implementation FRYNetworkEvent

- (id)init
{
    self = [super init];
    if ( self ) {
    }
    return self;
}

- (NSString *)filenamePrefix
{
    return [NSString stringWithFormat:@"%@-%@-%@",
            self.request.HTTPMethod,
            [self.request.URL host],
            [[[self.request.URL path] componentsSeparatedByString:@"/"] componentsJoinedByString:@"_"]];
}

- (NSString *)postContentType
{
    NSString *contentType = @"unknown";
    NSString *contentTypeHeader = [self.request valueForHTTPHeaderField:@"Content-Type"];
    NSArray *contentAbbreviations = @[@"json", @"xml", @"plist"];
    for ( NSString *contentAbbreviation in contentAbbreviations ) {
        if ( [ contentTypeHeader rangeOfString:contentAbbreviation options:NSCaseInsensitiveSearch].location != NSNotFound ) {
            contentType = contentAbbreviation;
        }
    }
    return contentType;
}

- (NSString *)responseContentType
{
    return [[self.response.suggestedFilename componentsSeparatedByString:@"."] lastObject];
}

- (NSString *)requestBodyFilename
{
    return [NSString stringWithFormat:@"%@.post.%@", self.filenamePrefix, self.postContentType];
}

- (NSString *)responseBodyFilename
{
    return [NSString stringWithFormat:@"%@.%@.%@", self.filenamePrefix, @(self.response.statusCode), self.responseContentType];
}

- (NSDictionary *)plistRepresentation
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionary];
    // This is strictly for documenting purposes, the request will be created from disk
    representation[@"URL"] = [self.request.URL absoluteString];
    if ( self.error ) {
        representation[@"error"] = @{@"domain":self.error.domain,
                                     @"code":@(self.error.code)};
    }
    representation[@"request.HTTPMethod"] = self.request.HTTPMethod;
    representation[@"request.allHTTPHeaderFields"] = self.request.allHTTPHeaderFields;

    if ( self.request.HTTPBodyStream ) {
        representation[@"request.HTTPBodyStream"] = @"Input Stream, unable to preserve";
    }
    if ( self.request.HTTPBody ) {
        representation[@"request.HTTPBody"] = [self requestBodyFilename];
    }

    representation[@"response.MIMEType"] = self.response.MIMEType;
    representation[@"response.allHeaderFields"] = self.response.allHeaderFields;
    representation[@"response.statusCode"] = @(self.response.statusCode);

    if ( self.data.length > 0 ) {
        representation[@"data"] = [self responseBodyFilename];
    }
    return [representation copy];
}

- (NSString *)recreationCode
{
    return @"// Add code for re-creation with Nocella";
}

- (NSString *)pathForFilename:(NSString *)filename inDirectory:(NSURL *)directory
{
    return [[directory URLByAppendingPathComponent:filename] path];
}

- (BOOL)saveAuxillaryFilesInDirectory:(NSURL *)directory error:(NSError **)error
{
    BOOL ok = YES;
    if ( self.request.HTTPBody ) {
        NSString *requestPath = [self pathForFilename:[self requestBodyFilename] inDirectory:directory];
        ok = [self.request.HTTPBody writeToFile:requestPath
                                        options:NSDataWritingWithoutOverwriting
                                          error:error];
        if ( ok == NO ) {
            return NO;
        }
    }

    if ( self.data.length > 0 ) {
        NSString *responsePath = [self pathForFilename:[self responseBodyFilename] inDirectory:directory];
        ok = [self.data writeToFile:responsePath
                            options:NSDataWritingWithoutOverwriting
                              error:error];
        if ( ok == NO ) {
            return NO;
        }
    }

    return YES;
}

@end
