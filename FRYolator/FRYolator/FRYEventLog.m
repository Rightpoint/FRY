//
//  FRYRecording.m
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYEventLog.h"
#import "FRYEvent.h"

@interface FRYEventLog ()

@property (strong, nonatomic) NSMutableArray *events;
@property (assign, nonatomic) NSTimeInterval enableTime;

@end

@implementation FRYEventLog

+ (NSURL *)eventLogDirectory
{
    NSURL *eventLogDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
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

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        _startingDate = [NSDate date];
        _enableTime = [[NSProcessInfo processInfo] systemUptime];
        _events = [NSMutableArray array];
    }
    return self;
}

- (void)addEvent:(FRYEvent *)event
{
    event.startingOffset -= self.enableTime;
    [self.events addObject:event];
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

- (NSDictionary *)plistRepresentation
{
    return @{
             NSStringFromSelector(@selector(appSchemeURL)) : self.appSchemeURL ? [self.appSchemeURL absoluteString] : @"",
             NSStringFromSelector(@selector(startingDate)) : self.startingDate,
             NSStringFromSelector(@selector(name)) : self.name,
             NSStringFromSelector(@selector(events)) : [self.events valueForKeyPath:NSStringFromSelector(@selector(plistRepresentation))]
             };
}

- (NSString *)commandsToReproduce;
{
    NSString *recreationCommandKey = NSStringFromSelector(@selector(recreationCode));
    return [[self.events valueForKey:recreationCommandKey] componentsJoinedByString:@"\n"];
}

- (BOOL)save:(NSError **)error
{
    NSLog(@"Saving to %@", [self eventBundlePath]);
    // FIXME: Strip non A-Za-z0-9 chars from name
    BOOL ok = [[NSFileManager defaultManager] createDirectoryAtURL:[self eventBundlePath]
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:error];
    if ( ok == NO ) {
        return NO;
    }
    ok = [[self plistRepresentation] writeToFile:[[self eventLogPath] path]
                                      atomically:YES];
    if ( ok == NO ) {
        *error = [NSError errorWithDomain:NSXMLParserErrorDomain
                                     code:-1
                                 userInfo:@{NSLocalizedDescriptionKey: @"Generated invalid plist representation"}];
    }
    // Give every event log a chance to save it's own event state
    for ( FRYEvent *event in self.events ) {
        ok = [event saveAuxillaryFilesInDirectory:[self eventBundlePath]
                                            error:error];
        if ( ok == NO ) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)load:(NSError **)error
{
    return YES;
}


@end
