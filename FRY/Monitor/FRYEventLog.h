//
//  FRYRecording.h
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An event log representing one recording.
 */
@interface FRYEventLog : NSObject

/**
 *  Load all of the event log objects in the specified directories
 *
 *  @param directory The directory to scan
 *
 *  @return An array of FRYEventLog objects that are populated with the information stored in the directory
 */
+ (NSArray *)loadFromDirectory:(NSURL *)directory;

/**
 *  The name entered by the user.  This is populated on load
 */
@property (copy, nonatomic) NSString *name;

/**
 *  The date that the event log was recorded.  This is populated on load
 */
@property (strong, nonatomic, readonly) NSDate *startingDate;

/**
 *  The app scheme URL that represents the page in the app that the touch
 *  stream begins
 */
@property (copy, nonatomic) NSURL *appSchemeURL;

/**
 *  An array of events.
 */
@property (copy, nonatomic) NSArray *events;

/**
 *  Load the detailed information from disk.
 *
 *  @param error An error object, if an error is encountered
 *
 *  @return YES on success.
 */
- (BOOL)load:(NSError **)error;

/**
 *  Save the event log to disk.
 *
 *  @param error An error object, if an error is encountered
 *
 *  @return YES on success.
 */
- (BOOL)save:(NSError **)error;

@end
