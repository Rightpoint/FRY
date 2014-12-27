//
//  FRYTracker.m
//  FRY
//
//  Created by Brian King on 12/22/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTracker.h"

@interface FRYTracker()

@property (assign, nonatomic) NSTimeInterval startTime;

@end

@implementation FRYTracker

- (instancetype)initWithDelegate:(id<FRYTrackerDelegate>)delegate
{
    self = [super init];
    if ( self ) {
        _delegate = delegate;
    }
    return self;
}

- (void)enable
{
    self.startTime = [self.delegate startTimeForEvents];
}

- (void)disable
{
    self.startTime = MAXFLOAT;
}

- (BOOL)isEnabled
{
    return self.startTime != MAXFLOAT;
}


@end
