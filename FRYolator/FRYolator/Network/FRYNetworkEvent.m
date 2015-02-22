//
//  FRYNetworkEvent.m
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYNetworkEvent.h"

@interface FRYNetworkEvent()

@property (strong, nonatomic) NSUUID *UUID;

@end

@implementation FRYNetworkEvent

- (id)init
{
    self = [super init];
    if ( self ) {
        self.UUID = [NSUUID UUID];
    }
    return self;
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
    return [representation copy];
}

- (NSString *)recreationCode
{
    return @"// Add code for re-creation with Nocella";
}

- (NSString *)pathInDirectory:(NSURL *)directory withExtension:(NSString *)extension
{
    NSString *filename = [NSString stringWithFormat:@"%@.%@", [self.UUID UUIDString], extension];
    return [[directory URLByAppendingPathComponent:filename] path];
}

- (BOOL)saveAuxillaryFilesInDirectory:(NSURL *)directory error:(NSError **)error
{
    BOOL ok = YES;
    NSParameterAssert(self.request);
    ok = [NSKeyedArchiver archiveRootObject:self.request toFile:[self pathInDirectory:directory withExtension:@"request"]];
    if ( ok == NO ) {
        return NO;
    }
    
    NSParameterAssert(self.response);
    ok = [NSKeyedArchiver archiveRootObject:self.response toFile:[self pathInDirectory:directory withExtension:@"response"]];
    if ( ok == NO ) {
        return NO;
    }

    NSParameterAssert(self.data);
    ok = [self.data writeToFile:[self pathInDirectory:directory withExtension:@"data"] atomically:YES];
    if ( ok == NO ) {
        return NO;
    }

    return YES;
}

@end
