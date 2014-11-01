//
//  FRYToucher.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRY.h"
#import "FRYActiveTouch.h"
#import "UIApplication+FRY.h"
#import "FRYLookup.h"
#import "FRYLookupSupport.h"
#import "FRYLookupResult.h"
#import "UIView+FRY.h"
#import "UITouch+FRY.h"

@interface FRY()

@property (strong, nonatomic) NSMutableArray *activeTouches;
@property (strong, nonatomic) NSMutableArray *activeChecks;

@property (assign, nonatomic) BOOL mainThreadDispatchEnabled;

@end

@implementation FRY

+ (FRY *)shared
{
    static FRY *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FRY alloc] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        self.activeTouches = [NSMutableArray array];
        self.activeChecks = [NSMutableArray array];
        [self setMainThreadDispatchEnabled:YES];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)addLookupCheck:(FRYCheckBlock)check
{
    [self.activeChecks addObject:[check copy]];
}

- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");

    CGRect touchFrameInWindow = [view.window convertRect:frame fromView:view];
    for ( __strong FRYSimulatedTouch *touch in touches ) {
        if ( [touch isKindOfClass:[FRYSyntheticTouch class]] ) {
            touch = [(FRYSyntheticTouch *)touch touchInFrame:touchFrameInWindow];
        }
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        FRYActiveTouch *touchInteraction = [[FRYActiveTouch alloc] initWithSimulatedTouch:touch inView:view startTime:startTime];
        
        NSLog(@"Performing Touch %@ on %@", touch, view);
        [self.activeTouches addObject:touchInteraction];
    }
}

- (void)pruneCompletedTouchInteractions
{
    for ( FRYActiveTouch *interaction in [self.activeTouches copy] ) {
        if ( interaction.currentTouchPhase == UITouchPhaseEnded || interaction.currentTouchPhase == UITouchPhaseCancelled ) {
            [self.activeTouches removeObject:interaction];
        }
    }
}

- (BOOL)hasActiveTouches
{
    return self.activeTouches.count > 0;
}

- (BOOL)hasActiveInteractions
{
    return self.activeChecks.count > 0;
}

- (void)clearInteractionsAndTouches
{
    [self.activeChecks removeAllObjects];

    // Generate an event for the distantFuture which will generate a 'last' event for all touches, and then prune all touches
    NSDate *distantFuture = [NSDate distantFuture];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:[distantFuture timeIntervalSinceReferenceDate]];
    if ( nextEvent ) {
        [[UIApplication sharedApplication] sendEvent:nextEvent];
    }
}

#pragma mark - Private

- (UIEvent *)eventForCurrentTouchesAtTime:(NSTimeInterval)time
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSMutableArray *touches = [NSMutableArray array];

    for ( FRYActiveTouch *interaction in self.activeTouches ) {
        UITouch *touch = [interaction touchAtTime:time];
        // Some active touches are delayed.   Ignore those here.
        if ( touch ) {
            [touches addObject:touch];
        }
    }
    [self pruneCompletedTouchInteractions];

    if ( touches.count > 0 ) {
        return [[UIApplication sharedApplication] fry_eventWithTouches:touches];
    }
    else {
        return nil;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p touches=%@, lookups=%@", self.class, self, self.activeTouches, self.activeChecks];
}

- (void)performAllLookups
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");

    for ( FRYCheckBlock checkBlock in [self.activeChecks copy] ) {
        if ( checkBlock() ) {
            [self.activeChecks removeObject:checkBlock];
        }
    }
}

- (void)sendNextEvent
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:currentTime];

    if ( nextEvent ) {
        [[UIApplication sharedApplication] sendEvent:nextEvent];
    }
}

- (void)setMainThreadDispatchEnabled:(BOOL)enabled
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    if ( _mainThreadDispatchEnabled != enabled ) {
        _mainThreadDispatchEnabled = enabled;
        
        if ( _mainThreadDispatchEnabled == YES ) {
            [self performSelector:@selector(sendNextEventAndPerformLookupsOnTimer) withObject:nil afterDelay:0.0];
        }
        else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    }
}

- (void)sendNextEventAndPerformLookupsOnTimer
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    [self performAllLookups];
    [self sendNextEvent];
    if ( self.mainThreadDispatchEnabled ) {
        [self performSelector:@selector(sendNextEventAndPerformLookupsOnTimer) withObject:nil afterDelay:kFRYEventDispatchInterval];
    }
}

@end