//
//  FRYToucher.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchDispatch.h"
#import "FRYActiveTouch.h"
#import "FRYTouch.h"
#import "UIApplication+FRY.h"
#import "UITouch+FRY.h"
#import "NSObject+FRYLookup.h"

@interface FRYTouchDispatch()

@property (strong, nonatomic) NSMutableArray *activeTouches;

@property (assign, nonatomic) BOOL mainThreadDispatchEnabled;

@end

@implementation FRYTouchDispatch

+ (FRYTouchDispatch *)shared
{
    static FRYTouchDispatch *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FRYTouchDispatch alloc] init];
    });
    return shared;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        self.activeTouches = [NSMutableArray array];
        [self setMainThreadDispatchEnabled:YES];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)asynchronouslySimulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame
{
    for ( __strong FRYTouch *touch in touches ) {
        if ( touch.pointsAreAbsolute == NO ) {
            touch = [touch touchInFrame:frame];
        }
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        FRYActiveTouch *touchInteraction = [[FRYActiveTouch alloc] initWithSimulatedTouch:touch inView:view startTime:startTime];
        
        NSLog(@"Dispatch %@ on %@", touch, view);
        [self.activeTouches addObject:touchInteraction];
    }
}

- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    
    [self.delegate touchDispatch:self willStartSimulationOfTouches:touches];

    [self asynchronouslySimulateTouches:touches inView:view frame:frame];
    
    [self.delegate touchDispatch:self didCompleteSimulationOfTouches:touches];
}

- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view
{
    [self simulateTouches:touches inView:view frame:[view fry_frameInWindow]];
}

- (void)pruneCompletedTouchInteractions
{
    NSMutableArray *completeTouches = [NSMutableArray array];
    for ( FRYActiveTouch *interaction in [self.activeTouches copy] ) {
        if ( interaction.currentTouchPhase == UITouchPhaseEnded || interaction.currentTouchPhase == UITouchPhaseCancelled ) {
            [self.activeTouches removeObject:interaction];
            [completeTouches addObject:interaction.touchDefinition];
        }
    }
}

- (BOOL)hasActiveTouches
{
    return self.activeTouches.count > 0;
}

- (NSTimeInterval)maxTouchDuration;
{
    NSTimeInterval duration = 0;
    for ( FRYActiveTouch *touch in [self.activeTouches copy] ) {
        duration = MAX(duration, [touch.touchDefinition duration]);
    }
    return duration;
}

- (void)clearInteractionsAndTouches
{
    // Generate an event for the distantFuture which will generate a 'last' event for all touches, and then prune all touches
    NSDate *distantFuture = [NSDate distantFuture];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:[distantFuture timeIntervalSinceReferenceDate]];
    if ( nextEvent ) {
        [[UIApplication sharedApplication] sendEvent:nextEvent];
    }
    [self pruneCompletedTouchInteractions];
}

#pragma mark - Private

- (UIEvent *)eventForCurrentTouchesAtTime:(NSTimeInterval)time
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSMutableArray *touches = [NSMutableArray array];

    for ( FRYActiveTouch *interaction in self.activeTouches ) {
        UITouch *touch = [interaction touchAtTime:time];
        // Some active touches are delayed. Ignore those here.
        if ( touch ) {
            [touches addObject:touch];
        }
    }

    if ( touches.count > 0 ) {
        return [[UIApplication sharedApplication] fry_eventWithTouches:touches];
    }
    else {
        return nil;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p touches=%@>", self.class, self, self.activeTouches];
}

- (void)sendNextEvent
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:currentTime];

    if ( nextEvent ) {
        [[UIApplication sharedApplication] sendEvent:nextEvent];
    }
    [self pruneCompletedTouchInteractions];
}

- (void)setMainThreadDispatchEnabled:(BOOL)enabled
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    if ( _mainThreadDispatchEnabled != enabled ) {
        _mainThreadDispatchEnabled = enabled;
        
        if ( _mainThreadDispatchEnabled == YES ) {
            [self performSelector:@selector(sendNextEventOnTimer) withObject:nil afterDelay:0.0];
        }
        else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
    }
}

- (void)sendNextEventOnTimer
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    [self sendNextEvent];
    if ( self.mainThreadDispatchEnabled ) {
        [self performSelector:@selector(sendNextEventOnTimer) withObject:nil afterDelay:kFRYEventDispatchInterval];
    }
}

@end
