//
//  FRYToucher.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRY.h"
#import "FRYTouchInteraction.h"
#import "UIApplication+FRY.h"

static NSTimeInterval const kFRYEventDispatchInterval = 0.1;

@interface FRY()

/**
 * The application to interact with.  This defaults to [UIApplication sharedApplication]
 * but is exposed for testing reasons
 */
@property (strong, nonatomic) UIApplication *application;

@property (copy, nonatomic) NSMutableArray *activeTouchInteractions;
@property (copy, nonatomic) NSMutableArray *activeLookups;

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
        self.activeTouchInteractions = [NSMutableArray array];
        self.activeLookups = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)addTouchWithDefinition:(FRYTouchDefinition *)touchDefinition inView:(UIView *)view
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    FRYTouchInteraction *touchInteraction = [[FRYTouchInteraction alloc] initWithTouchDefinition:touchDefinition inView:view startTime:startTime];

    @synchronized(self.activeTouchInteractions) {
        [self.activeTouchInteractions addObject:touchInteraction];
    }
}

- (void)addTouchWithDefinitions:(NSArray *)touchDefinitions inView:(UIView *)view
{
    for ( FRYTouchDefinition *definition in touchDefinitions ) {
        [self addTouchWithDefinition:definition inView:view];
    }
}

- (void)pruneCompletedTouchInteractions
{
    @synchronized(self.activeTouchInteractions) {
        for ( FRYTouchInteraction *interaction in [self.activeTouchInteractions copy] ) {
            if ( interaction.currentTouchPhase == UITouchPhaseEnded || interaction.currentTouchPhase == UITouchPhaseCancelled ) {
                [self.activeTouchInteractions removeObject:interaction];
            }
        }
    }
}

- (BOOL)hasActiveTouches
{
    @synchronized(self.activeTouchInteractions) {
        return self.activeTouchInteractions.count > 0;
    }
}

- (void)addLookup:(FRYLookup *)lookup
{
    [lookup setValue:self.application forKey:NSStringFromSelector(@selector(application))];
    @synchronized(self.activeLookups) {
        [self.activeLookups addObject:lookup];
    }
}

- (BOOL)hasActiveLookups
{
    @synchronized(self.activeLookups) {
        return self.activeLookups.count > 0;
    }
}

- (void)clearLookupsAndTouches
{
    [self.activeLookups removeAllObjects];

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
    
    @synchronized(self.activeTouchInteractions) {
        for ( FRYTouchInteraction *interaction in self.activeTouchInteractions ) {
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
    NSMutableArray *lookupCompletionBlocks = [NSMutableArray array];
    
//    @synchronized(self.activeLookups) {
//        for ( FRYLookup *lookup in [self.activeLookups copy] ) {
//            FRYLookupComplete completion = [lookup foundBlockIfLookupIsFound];
//            if ( completion ) {
//                [self.activeLookups removeObject:lookup];
//                [lookupCompletionBlocks addObject:completion];
//            }
//        }
//    }
//    for ( FRYLookupComplete completionBlock in lookupCompletionBlocks ) {
//        completionBlock();
//    }
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