//
//  FRYRecording.m
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYEventLog.h"

@implementation FRYEventLog

+ (NSURL *)eventLogDirectory
{
    NSURL *eventLogDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSUserDirectory inDomains:NSUserDomainMask] lastObject];
    return eventLogDirectory;
}

+ (NSArray *)loadFromDirectory:(NSURL *)directory
{
    return @[];
}

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy_MMM_EEE_HH:mm:ss"];
    });
    return formatter;
}

- (NSString *)eventLogNameForPath
{
    return [[self.name componentsSeparatedByString:@" "] componentsJoinedByString:@"_"];
}

- (NSString *)eventLogDateForPath
{
    return [self.class.dateFormatter stringFromDate:self.startingDate];
}

- (NSURL *)eventBundlePath
{
    NSString *combined = [@[[self eventLogDateForPath], [self eventLogNameForPath]] componentsJoinedByString:@"-_-"];
    return [[self.class eventLogDirectory] URLByAppendingPathComponent:[combined stringByAppendingString:@".fry"]];
}

- (NSURL *)eventLogPath
{
    return [[self eventBundlePath] URLByAppendingPathComponent:@"EventLog.plist"];
}

- (BOOL)save:(NSError **)error
{
    return YES;
}

- (BOOL)load:(NSError **)error
{
    return YES;
}


@end
