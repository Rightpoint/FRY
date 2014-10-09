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
#import "FRYInteraction.h"
#import "FRYLookup.h"
#import "FRYLookupSupport.h"

static NSTimeInterval const kFRYEventDispatchInterval = 0.1;

@interface FRY()

/**
 * The application to interact with.  This defaults to [UIApplication sharedApplication]
 * but is exposed for testing reasons
 */
@property (strong, nonatomic) UIApplication *application;

@property (copy, nonatomic) NSMutableArray *activeTouches;
@property (copy, nonatomic) NSMutableArray *activeInteractions;

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
        self.application = [UIApplication sharedApplication];
        self.activeTouches = [NSMutableArray array];
        self.activeInteractions = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)simulateTouch:(FRYSimulatedTouch *)touch matchingView:(NSDictionary *)lookupVariables
{
    [self simulateTouch:touch matchingView:lookupVariables inTargetWindow:FRYTargetWindowKey];
}
- (void)simulateTouch:(FRYSimulatedTouch *)touch matchingView:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow
{
    [self simulateTouches:@[touch] matchingView:lookupVariables inTargetWindow:targetWindow];
}

- (void)simulateTouches:(NSArray *)touches matchingView:(NSDictionary *)lookupVariables
{
    [self simulateTouches:touches matchingView:lookupVariables inTargetWindow:FRYTargetWindowKey];
}

- (void)simulateTouches:(NSArray *)touches matchingView:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow
{
    [self findMatchingView:lookupVariables inTargetWindow:targetWindow whenFound:^(UIView *view) {
        for ( FRYSimulatedTouch *touch in touches ) {
            [self addTouch:touch inView:view];
        }
    }];
}

- (void)findMatchingView:(NSDictionary *)lookupVariables whenFound:(FRYInteractionBlock)foundBlock
{
    [self findMatchingView:lookupVariables inTargetWindow:FRYTargetWindowKey whenFound:foundBlock];
}

- (void)findMatchingView:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow whenFound:(FRYInteractionBlock)foundBlock
{
    FRYInteraction *interaction = [FRYInteraction interactionWithTargetWindow:targetWindow lookupVariables:lookupVariables foundBlock:foundBlock];
    @synchronized(self.activeInteractions) {
        [self.activeInteractions addObject:interaction];
    }
}

- (void)addTouch:(FRYSimulatedTouch *)touch inView:(UIView *)view
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    FRYActiveTouch *touchInteraction = [[FRYActiveTouch alloc] initWithSimulatedTouch:touch inView:view startTime:startTime];

    @synchronized(self.activeTouches) {
        [self.activeTouches addObject:touchInteraction];
    }
}

- (void)pruneCompletedTouchInteractions
{
    @synchronized(self.activeTouches) {
        for ( FRYActiveTouch *interaction in [self.activeTouches copy] ) {
            if ( interaction.currentTouchPhase == UITouchPhaseEnded || interaction.currentTouchPhase == UITouchPhaseCancelled ) {
                [self.activeTouches removeObject:interaction];
            }
        }
    }
}

- (BOOL)hasActiveTouches
{
    @synchronized(self.activeTouches) {
        return self.activeTouches.count > 0;
    }
}

- (BOOL)hasActiveInteractions
{
    @synchronized(self.activeInteractions) {
        return self.activeInteractions.count > 0;
    }
}

- (void)clearInteractionsAndTouches
{
    [self.activeInteractions removeAllObjects];

    // Generate an event for the distantFuture which will generate a 'last' event for all touches
    NSDate *distantFuture = [NSDate distantFuture];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:[distantFuture timeIntervalSinceReferenceDate]];
    [self.application sendEvent:nextEvent];
}

#pragma mark - Private

- (UIEvent *)eventForCurrentTouchesAtTime:(NSTimeInterval)time
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSMutableArray *touches = [NSMutableArray array];
    
    @synchronized(self.activeTouches) {
        for ( FRYActiveTouch *interaction in self.activeTouches ) {
            [touches addObject:[interaction touchAtTime:time]];
        }
        [self pruneCompletedTouchInteractions];
    }
    return [self.application fry_eventWithTouches:touches];
}

@end

@implementation FRY(Dispatch)

- (void)performAllLookups
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");

    NSArray *activeInteractions = nil;
    @synchronized(self.activeInteractions) {
        activeInteractions = [self.activeInteractions copy];
    }
    NSMutableArray *completedInteractions = [NSMutableArray array];
    for ( FRYInteraction *interaction in [self.activeInteractions copy] ) {
        NSArray *matching = @[];
        for ( UIWindow *window in [self.application fry_targetWindowsOfType:interaction.targetWindow] ) {
            id<FRYLookup> lookup = [window.class fry_lookup];
            NSArray *matchingInWindow = [lookup lookupChildrenOfObject:window matchingVariables:interaction.lookupVariables];
            matching = [matching arrayByAddingObjectsFromArray:matchingInWindow];
        }
        NSAssert(matching.count == 1, @"Found more matching views than I can handle!");
        interaction.foundBlock(matching.lastObject);
        [completedInteractions addObject:interaction];
    }

    @synchronized(self.activeInteractions) {
        [self.activeInteractions removeObjectsInArray:completedInteractions];
    }
}

- (void)sendNextEvent
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:currentTime];

    [self.application sendEvent:nextEvent];
    
    for ( UITouch *touch in nextEvent.allTouches ) {
        if ( touch.phase == UITouchPhaseEnded && [touch.view canBecomeFirstResponder] ) {
            [touch.view becomeFirstResponder];
        }
    }
}

- (void)setMainThreadDispatchEnabled:(BOOL)enabled
{
    if ( _mainThreadDispatchEnabled != enabled ) {
        _mainThreadDispatchEnabled = enabled;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ( _mainThreadDispatchEnabled == YES ) {
                [self performSelector:@selector(sendNextEventAndPerformLookupsOnTimer) withObject:nil afterDelay:0.0];
            }
            else {
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
            }
        });
    }
}

- (void)sendNextEventAndPerformLookupsOnTimer
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    [self sendNextEvent];
    if ( self.mainThreadDispatchEnabled ) {
        [self performSelector:@selector(sendNextEventAndPerformLookupsOnTimer) withObject:nil afterDelay:kFRYEventDispatchInterval];
    }
}

@end