//
//  FRYTouchMonitor.m
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYolator.h"

#import "FRYEventLog.h"

#import "FRYTouchTracker.h"
#import "FRYNetworkTracker.h"

#import "FRYTouchHighlightWindowLayer.h"
#import "FRYMethodSwizzling.h"

NSString *FRYolatorEnabledUserPreferencesKeyPath = @"FRYolatorEnabled";

@interface FRYolator() <FRYTrackerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) FRYTouchTracker *touchTracker;
@property (strong, nonatomic) FRYNetworkTracker *networkTracker;

@property (strong, nonatomic) FRYTouchHighlightWindowLayer *highlightLayer;

@property (strong, nonatomic) UITapGestureRecognizer *recordGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *presentUIGestureRecognizer;

@property (assign, nonatomic) BOOL enabled;
@property (strong, nonatomic) FRYEventLog *eventLog;

@end

@implementation FRYolator

+ (FRYolator *)shared
{
    static FRYolator *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FRYMethodSwizzling exchangeClass:[UIApplication class]
                                   method:@selector(sendEvent:)
                                withClass:[self class]
                                   method:@selector(fry_sendEvent:)];

        monitor = [[FRYolator alloc] init];
    });
    return monitor;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.touchTracker = [[FRYTouchTracker alloc] initWithDelegate:self];
        self.networkTracker = [[FRYNetworkTracker alloc] initWithDelegate:self];
        self.highlightLayer = [[FRYTouchHighlightWindowLayer alloc] init];

        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:FRYolatorEnabledUserPreferencesKeyPath
                                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                                                   context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self
                                               forKeyPath:FRYolatorEnabledUserPreferencesKeyPath
                                                  context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:FRYolatorEnabledUserPreferencesKeyPath] ) {
        id value = [change objectForKey:NSKeyValueChangeNewKey];
        if ( [value isEqual:[NSNull null]] == NO ) {
            BOOL enabled = [value boolValue];
            [[NSOperationQueue currentQueue] addOperationWithBlock:^{
                if ( enabled && self.enabled == NO ) {
                    [self enable];
                }
                else if ( enabled == NO && self.enabled ) {
                    [self disable];
                }
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)enable
{
    self.eventLog = [[FRYEventLog alloc] init];
    if ( [self.delegate respondsToSelector:@selector(appSchemeURLRepresentingCurrentStateForFryolator:)] ) {
        self.eventLog.appSchemeURL = [self.delegate appSchemeURLRepresentingCurrentStateForFryolator:self];
    }

    [self.touchTracker enable];
    [self.networkTracker enable];
    [self.highlightLayer enable];
    self.enabled = YES;
}

- (void)disable
{
    [self.touchTracker disable];
    [self.networkTracker disable];
    [self.highlightLayer disable];
    self.enabled = NO;
}

- (BOOL)saveEventLogNamed:(NSString *)eventLogName error:(NSError **)error
{
    self.eventLog.name = eventLogName;
    BOOL status = [self.eventLog save:error];
    [self clearEventLog];
    return status;
}

- (void)clearEventLog
{
    self.eventLog = nil;
}

- (void)fry_sendEvent:(UIEvent *)event
{
    [self fry_sendEvent:event];
    if ( FRYolator.shared.enabled ) {
        [FRYolator.shared.touchTracker trackEvent:event];
        [FRYolator.shared.highlightLayer visualizeEvent:event];
    }
}

- (void)tracker:(FRYTracker *)tracker recordEvent:(FRYEvent *)event
{
    [self.eventLog addEvent:event];
}

@end
