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
#import "FRYRecordedTouch.h"

@interface FRYEventMonitor()

@property (assign, nonatomic) NSTimeInterval startTime;
@property (strong, nonatomic) NSMutableArray *touchDefinitions;

@property (strong, nonatomic) NSMapTable *activeTouches;

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
    self.activeTouches = [NSMapTable weakToStrongObjectsMapTable];
}

- (void)disable
{
    self.touchDefinitions = nil;
    self.activeTouches = nil;
    self.startTime = MAXFLOAT;
    // This is wishful, and does not work.   I am wishful and would like it to, so ima gonna leave it here.
    [FRYMethodSwizzling exchangeClass:[self class]
                               method:@selector(fry_sendEvent:)
                            withClass:[UIApplication class]
                               method:@selector(sendEvent:)];
}

- (void)fry_sendEvent:(UIEvent *)event
{
    [self fry_sendEvent:event];
    [[FRYEventMonitor sharedEventMonitor] monitorEvent:event];
}

- (NSTimeInterval)relativeTime:(NSTimeInterval)time
{
    return time - self.startTime;
}

- (void)monitorEvent:(UIEvent *)event
{
    for ( UITouch *touch in [event allTouches] ) {
        NSTimeInterval relativeTouchTime = [self relativeTime:touch.timestamp];
        FRYRecordedTouch *definition = nil;
        if ( touch.phase == UITouchPhaseBegan ) {
            definition = [[FRYRecordedTouch alloc] init];
            definition.startingOffset = relativeTouchTime;
            [self.activeTouches setObject:definition forKey:touch];
        }
        else {
            definition = [self.activeTouches objectForKey:touch];
        }
        CGPoint location = [touch locationInView:touch.view];
        [definition addLocation:location atRelativeTime:relativeTouchTime];
        
        if ( touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled ) {
            [self.touchDefinitions addObject:[self.activeTouches objectForKey:touch]];
            [self.activeTouches removeObjectForKey:touch];
        }
    }
}

@end
