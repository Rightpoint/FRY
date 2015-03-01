//
//  FRYTracker.h
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYEvent.h"

@class FRYTracker;

@protocol FRYTrackerDelegate <NSObject>

- (void)tracker:(FRYTracker *)tracker recordEvent:(FRYEvent *)event;

@end

/**
 *  An abstract base class that provides a mechanism for tracking events
 */
@interface FRYTracker : NSObject

- (instancetype)initWithDelegate:(id<FRYTrackerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)enable;
- (void)disable;

@property (assign, nonatomic, readonly) id<FRYTrackerDelegate>delegate;

@end
