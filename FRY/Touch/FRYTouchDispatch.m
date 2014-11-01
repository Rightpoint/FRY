//
//  FRYToucher.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchDispatch.h"
#import "FRYActiveTouch.h"
#import "FRYSyntheticTouch.h"
#import "UIApplication+FRY.h"
#import "UIView+FRY.h"
#import "UITouch+FRY.h"

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

- (void)clearInteractionsAndTouches
{
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
