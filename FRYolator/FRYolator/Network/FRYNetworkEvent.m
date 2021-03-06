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

static FRYNetworkEventCodeGenerationStyle s_codeGenerationStyle;

@implementation FRYNetworkEvent

+ (void)setCodeGenerationStyle:(FRYNetworkEventCodeGenerationStyle)codeGenerationStyle
{
    s_codeGenerationStyle = codeGenerationStyle;
}

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

    if ( self.response ) {
        representation[@"response.MIMEType"] = self.response.MIMEType;
        representation[@"response.allHeaderFields"] = self.response.allHeaderFields;
        representation[@"response.statusCode"] = @(self.response.statusCode);
    }
    if ( self.data.length > 0 ) {
        representation[@"data"] = [self responseBodyFilename];
    }
    return [representation copy];
}

- (NSString *)representationForHeaderDictionary:(NSDictionary *)dictionary
{
    NSMutableString *headerStubs = [NSMutableString string];
    [headerStubs appendString:@"@{\n"];
    NSMutableArray *headerStrings = [NSMutableArray array];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        NSString *match = [NSString stringWithFormat:@"@\"%@\": @\"%@\"", key, value];
        [headerStrings addObject:match];
    }];
    [headerStubs appendString:[headerStrings componentsJoinedByString:@",\n"]];
    [headerStubs appendString:@"}\n"];
    return [headerStubs copy];
}

- (NSString *)nocillaRecreationHeadersForDictionary:(NSDictionary *)dictionary
{
    return [NSString stringWithFormat:@".withHeaders(%@)\n", [self representationForHeaderDictionary:dictionary]];
}

- (NSString *)nocillaRecreationCode
{
    NSMutableString *stub = [NSMutableString stringWithFormat:@"stubRequest(@\"%@\", @\"%@\")\n",
                             self.request.HTTPMethod, self.request.URL];
    if ( self.request.allHTTPHeaderFields.count > 0 ) {
        [stub appendString:[self nocillaRecreationHeadersForDictionary:self.request.allHTTPHeaderFields]];
    }
    if ( self.request.HTTPBody ) {
        [stub appendFormat:@".withBody([NSData dataWithContentsOfFile:@\"%@\"])\n", [self requestBodyFilename]];
    }
    [stub appendFormat:@".andReturn(%zd)\n", self.response.statusCode];
    if ( self.response.allHeaderFields ) {
        [stub appendString:[self nocillaRecreationHeadersForDictionary:self.response.allHeaderFields]];
    }
    if ( self.data.length > 0 ) {
        [stub appendFormat:@".withBody([NSData dataWithContentsOfFile:@\"%@\"])\n", [self responseBodyFilename]];
    }
    return [stub copy];
}

- (NSString *)ohhttpStubsRecreationCode
{
    NSArray *matches = @[[NSString stringWithFormat:@"[request.URL.resourceSpecifier isEqual:@\"%@\"]", self.request.URL.resourceSpecifier],
                         [NSString stringWithFormat:@"[request.URL.scheme isEqual:@\"%@\"]", self.request.URL.scheme],
                         ];

    NSString *response = [NSString stringWithFormat:@"\
return [OHHTTPStubsResponse responseWithFileAtPath:@\"%@\"\n\
                                            statusCode:%zd\n\
                                               headers:%@]",
                          [self responseBodyFilename],
                          self.response.statusCode,
                          [self representationForHeaderDictionary:self.request.allHTTPHeaderFields]];

    NSString *stub = [NSString stringWithFormat:@"\
[OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {\n\
    return %@;\n\
} withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {\n\
    %@;\n\
}];\n\n", [matches componentsJoinedByString:@" && "], response];
    return stub;
}

- (NSString *)recreationCode
{
    NSString *recreationCode = nil;
    if ( s_codeGenerationStyle == FRYNetworkEventCodeGenerationStyleNocilla ) {
        recreationCode = [self nocillaRecreationCode];
    }
    else if ( s_codeGenerationStyle == FRYNetworkEventCodeGenerationStyleOHHTTPStubs ) {
        recreationCode = [self ohhttpStubsRecreationCode];
    }
    NSString *comment = [NSString stringWithFormat:@"// Ensure the file '%@' is added to your test target\n", [self responseBodyFilename]];
    recreationCode = [comment stringByAppendingString:recreationCode];
    return recreationCode;
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
