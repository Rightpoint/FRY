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
#import "FRYLookupResult.h"
#import "UIView+FRY.h"

@interface FRY()

/**
 * The application to interact with.  This defaults to [UIApplication sharedApplication]
 * but is exposed for testing reasons
 */
@property (strong, nonatomic) UIApplication *application;

@property (strong, nonatomic) NSMutableArray *activeTouches;
@property (strong, nonatomic) NSMutableArray *activeInteractions;

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
        [self setMainThreadDispatchEnabled:YES];
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
    if ( lookupVariables ) {
        [self findViewsMatching:lookupVariables inTargetWindow:targetWindow whenFound:^(NSArray *results) {
            results = [FRYLookupResult removeAncestorsFromLookupResults:results];
            NSParameterAssert(results.count == 1);
            FRYLookupResult *result = [results lastObject];
            [self simulateTouches:touches inView:result.view frame:result.frame];
        }];
    }
    else {
        NSArray *windows = [self.application fry_targetWindowsOfType:targetWindow];
        NSAssert(windows.count == 1, @"Must specify a matching view or a singular target window");
        UIWindow *window = [windows firstObject];
        UIView *view = [window.subviews lastObject];
        [self simulateTouches:touches inView:view frame:view.bounds];
    }
}

- (void)simulateTouches:(NSArray *)touches inView:(UIView *)view frame:(CGRect)frame
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");

    CGRect touchFrameInWindow = [view.window convertRect:frame fromView:view];
    for ( __strong FRYSimulatedTouch *touch in touches ) {
        if ( [touch isKindOfClass:[FRYSyntheticTouch class]] ) {
            touch = [(FRYSyntheticTouch *)touch touchInFrame:touchFrameInWindow];
        }
        [self addTouch:touch inView:view];
    }
}

- (void)findViewsMatching:(NSDictionary *)lookupVariables whenFound:(FRYInteractionBlock)foundBlock
{
    [self findViewsMatching:lookupVariables inTargetWindow:FRYTargetWindowKey whenFound:foundBlock];
}

- (void)findViewsMatching:(NSDictionary *)lookupVariables inTargetWindow:(FRYTargetWindow)targetWindow whenFound:(FRYInteractionBlock)foundBlock
{
    FRYInteraction *interaction = [FRYInteraction interactionWithTargetWindow:targetWindow lookupVariables:lookupVariables foundBlock:foundBlock];
    @synchronized(self.activeInteractions) {
        [self.activeInteractions addObject:interaction];
    }
}

- (void)replaceTextWithString:(NSString *)string intoView:(UIView *)view
{
    NSAssert([view conformsToProtocol:@protocol(UITextInput)], @"%@ does not conform to UITextInput", view);
    UIView<UITextInput> *inputView = (id)view;
    
    UITextPosition *begin = inputView.beginningOfDocument;
    UITextPosition *end   = inputView.endOfDocument;
    UITextRange *allText  = [inputView textRangeFromPosition:begin toPosition:end];
    [inputView replaceRange:allText withText:string];
}

- (void)addTouch:(FRYSimulatedTouch *)touch inView:(UIView *)view
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    FRYActiveTouch *touchInteraction = [[FRYActiveTouch alloc] initWithSimulatedTouch:touch inView:view startTime:startTime];

    @synchronized(self.activeTouches) {
        NSLog(@"Performing Touch %@ on %@", touch, view);
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

- (UIView *)animatingViewToWaitFor
{
    return [self animatingViewToWaitForInTargetWindow:FRYTargetWindowKey];
}

- (UIView *)animatingViewToWaitForInTargetWindow:(FRYTargetWindow)targetWindow
{
    __block UIView *animatingView = nil;
    if ( [NSThread isMainThread] ) {
        for ( UIWindow *window in [self.application fry_targetWindowsOfType:targetWindow] ) {
            UIView *animatingViewInWindow = [window fry_animatingViewToWaitFor];
            if ( animatingViewInWindow ) {
                animatingView = animatingViewInWindow;
                break;
            }
        }
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            animatingView = [self animatingViewToWaitForInTargetWindow:targetWindow];
        });
    }
    return animatingView;
}


- (void)clearInteractionsAndTouches
{
    @synchronized(self.activeInteractions) {
        [self.activeInteractions removeAllObjects];
    }

    // Generate an event for the distantFuture which will generate a 'last' event for all touches, and then prune all touches
    NSDate *distantFuture = [NSDate distantFuture];
    UIEvent *nextEvent = [self eventForCurrentTouchesAtTime:[distantFuture timeIntervalSinceReferenceDate]];
    if ( nextEvent ) {
        [self.application sendEvent:nextEvent];
    }
}

#pragma mark - Private

- (UIEvent *)eventForCurrentTouchesAtTime:(NSTimeInterval)time
{
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"");
    NSMutableArray *touches = [NSMutableArray array];

    @synchronized(self.activeTouches) {
        for ( FRYActiveTouch *interaction in self.activeTouches ) {
            UITouch *touch = [interaction touchAtTime:time];
            // Some active touches are delayed.   Ignore those here.
            if ( touch ) {
                [touches addObject:touch];
            }
        }
        [self pruneCompletedTouchInteractions];
    }
    if ( touches.count > 0 ) {
        return [self.application fry_eventWithTouches:touches];
    }
    else {
        return nil;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p touches=%@, lookups=%@, animating=%@", self.class, self, self.activeTouches, self.activeInteractions, self.animatingViewToWaitFor ? @"Waiting" : @"Ready"];
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
    for ( FRYInteraction *interaction in activeInteractions ) {
        if ( [self animatingViewToWaitForInTargetWindow:interaction.targetWindow] ) {
            continue;
        }
                
        NSArray *matching = @[];
        for ( UIWindow *window in [self.application fry_targetWindowsOfType:interaction.targetWindow] ) {
            id<FRYLookup> lookup = [window.class fry_lookup];
            NSArray *matchingInWindow = [lookup lookupChildrenOfObject:window matchingVariables:interaction.lookupVariables];
            matching = [matching arrayByAddingObjectsFromArray:matchingInWindow];
        }
        if ( matching.count > 0 ) {
            NSLog(@"Lookup for %@ found %@", interaction.lookupVariables, matching);
            
            interaction.foundBlock(matching);
            [completedInteractions addObject:interaction];
        }
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

    if ( nextEvent ) {
        [self.application sendEvent:nextEvent];
        
        for ( UITouch *touch in nextEvent.allTouches ) {
            if ( touch.phase == UITouchPhaseEnded && [touch.view canBecomeFirstResponder] ) {
                [touch.view becomeFirstResponder];
            }
        }
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