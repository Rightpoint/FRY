//
//  FRYEventMonitor.m
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchRecorder.h"
#import "UIKit+FRYExposePrivate.h"
#import "FRYTouchEventLog.h"
#import "UIView+FRY.h"
#import "UITouch+FRY.h"

@interface FRYTouchRecorder()

@property (assign, nonatomic) NSTimeInterval startTime;
@property (strong, nonatomic) NSMutableArray *touchDefinitions;

@property (strong, nonatomic) NSMapTable *activeTouchLog;
@property (strong, nonatomic) NSMapTable *touchBeganOnViews;

@end

@implementation FRYTouchRecorder

- (void)enable
{
    self.startTime = [[NSProcessInfo processInfo] systemUptime];
    self.touchDefinitions = [NSMutableArray array];
    self.activeTouchLog = [NSMapTable weakToStrongObjectsMapTable];
    self.touchBeganOnViews = [NSMapTable weakToStrongObjectsMapTable];
}

- (void)disable
{
    self.touchDefinitions = nil;
    self.activeTouchLog = nil;
    self.startTime = MAXFLOAT;
}

- (void)recordEvent:(UIEvent *)event
{
    if ( self.startTime == MAXFLOAT ) {
        return;
    }
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
            if ( touch.view == nil && touchedView && [touchedView isFirstResponder] == NO ) {
                log.viewLookupVariables = nil;
            }
            if ( touchedView && log.viewLookupVariables ) {
                [log translateTouchesIntoViewCoordinates:touchedView];
            }
            [self.touchDefinitions addObject:[self.activeTouchLog objectForKey:touch]];
            [self.activeTouchLog removeObjectForKey:touch];
            [self.touchBeganOnViews removeObjectForKey:touch];
        }
    }
}

- (void)printTouchLog
{
    for ( FRYTouchEventLog *log in self.touchDefinitions ) {
        printf("%s", [[log recreationCode] UTF8String]);
        printf("\n");
    }
}

@end
