//
//  FRYEventMonitor.m
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYEventMonitor.h"
#import "FRYMethodSwizzling.h"
#import "UIKit+FRYExposePrivate.h"
#import "FRYTouchEventLog.h"
#import "UIView+FRY.h"
#import "UITouch+FRY.h"

@interface FRYEventMonitor()

@property (assign, nonatomic) NSTimeInterval startTime;
@property (strong, nonatomic) NSMutableArray *touchDefinitions;

@property (strong, nonatomic) NSMapTable *activeTouchLog;
@property (strong, nonatomic) NSMapTable *touchBeganOnViews;

@end

@implementation FRYEventMonitor

+ (void)load
{
    [[self sharedEventMonitor] enable];
}


+ (FRYEventMonitor *)sharedEventMonitor
{
    static FRYEventMonitor *monitor = nil;
    if ( monitor == nil ) {
        monitor = [[FRYEventMonitor alloc] init];
    }
    return monitor;
}

- (void)enable
{
    [FRYMethodSwizzling exchangeClass:[UIApplication class]
                               method:@selector(sendEvent:)
                            withClass:[self class]
                               method:@selector(fry_sendEvent:)];
    self.startTime = [[NSProcessInfo processInfo] systemUptime];
    self.touchDefinitions = [NSMutableArray array];
    self.activeTouchLog = [NSMapTable weakToStrongObjectsMapTable];
    self.touchBeganOnViews = [NSMapTable weakToStrongObjectsMapTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(printTouchLogOnResign)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
                                                                
}

- (void)disable
{
    self.touchDefinitions = nil;
    self.activeTouchLog = nil;
    self.startTime = MAXFLOAT;
    [FRYMethodSwizzling exchangeClass:[UIApplication class]
                               method:@selector(sendEvent:)
                            withClass:[self class]
                               method:@selector(fry_sendEvent:)];
}

- (void)fry_sendEvent:(UIEvent *)event
{
    [self fry_sendEvent:event];
    [[FRYEventMonitor sharedEventMonitor] monitorEvent:event];
}

- (void)monitorEvent:(UIEvent *)event
{
    for ( UITouch *touch in [event allTouches] ) {
        NSTimeInterval relativeTouchTime = touch.timestamp - self.startTime;
        FRYTouchEventLog *log = nil;

        if ( touch.phase == UITouchPhaseBegan ) {
            log = [[FRYTouchEventLog alloc] init];
            log.startingOffset = relativeTouchTime;
            CGPoint locationInView = [touch locationInView:touch.view];
            UIView *matchingView = [touch.view fry_lookupMatchingViewAtPoint:locationInView];
            while ( matchingView && [matchingView fry_matchingLookupVariables] == nil ) {
                matchingView = [matchingView superview];
            }
            log.viewLookupVariables = [matchingView fry_matchingLookupVariables];
            [self.activeTouchLog setObject:log forKey:touch];
            [self.touchBeganOnViews setObject:touch.view forKey:touch];
        }
        else {
            log = [self.activeTouchLog objectForKey:touch];
        }
        CGPoint location = [touch locationInView:nil];
        [log addLocation:location atRelativeTime:relativeTouchTime];
        
        if ( touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled ) {
            UIView *touchedView = [self.touchBeganOnViews objectForKey:touch];
            // Discard the lookup variables if the touch left the view and the view wasn't made first responder.
            // the first responder check was added because touching a UITextField caused the touches view to disappear.
            if ( touch.view == nil && [touchedView isFirstResponder] == NO ) {
                log.viewLookupVariables = nil;
            }
            if ( touch.view && log.viewLookupVariables ) {
                [log translateTouchesIntoViewCoordinates:touch.view];
            }
            [self.touchDefinitions addObject:[self.activeTouchLog objectForKey:touch]];
            [self.activeTouchLog removeObjectForKey:touch];
            [self.touchBeganOnViews removeObjectForKey:touch];
        }
    }
}

- (void)printTouchLogOnResign
{
    for ( FRYTouchEventLog *log in self.touchDefinitions ) {
        printf("%s", [[log recreationCode] UTF8String]);
        printf("[[NSRunLoop currentRunLoop] fry_waitForIdle];\n\n");
    }
}

@end
