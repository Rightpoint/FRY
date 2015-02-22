//
//  FRYEventLog.m
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYEvent.h"

@implementation FRYEvent

- (NSDictionary *)plistRepresentation
{
    return @{};
}

- (NSString *)recreationCode
{
    return @"// No Op";
}

- (BOOL)saveAuxillaryFilesInDirectory:(NSURL *)directory error:(NSError **)error
{
    return YES;
}

@end
