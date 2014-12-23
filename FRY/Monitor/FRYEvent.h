//
//  FRYEventLog.h
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A FRYEvent represents some action in the application that can
 *  be recorded, and potentially re-created.   These objects are created
 *  by FRYTracker subclasses.
 */
@interface FRYEvent : NSObject

@property (assign, nonatomic) NSTimeInterval startingOffset;

- (NSDictionary *)representation;

- (NSString *)recreationCode;

@end
