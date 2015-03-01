//
//  FRYEventMonitor.m
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchTracker.h"
#import "FRYTouchEvent.h"

#import "UIView+FRYLookup.h"

#import "FRYTouchEvent.h"

@interface FRYTouchTracker()

@property (strong, nonatomic) NSMapTable *activeTouchLog;
@property (strong, nonatomic) NSMapTable *touchBeganOnViews;

@end

@implementation FRYTouchTracker

- (void)enable
{
    [super enable];
    self.activeTouchLog = [NSMapTable weakToStrongObjectsMapTable];
    self.touchBeganOnViews = [NSMapTable weakToStrongObjectsMapTable];
}

- (void)disable
{
    [super disable];
    self.activeTouchLog = nil;
    self.touchBeganOnViews = nil;
}

- (void)trackEvent:(UIEvent *)event
{
    for ( UITouch *touch in [event allTouches] ) {
        FRYTouchEvent *log = nil;

        if ( touch.phase == UITouchPhaseBegan ) {
            log = [[FRYTouchEvent alloc] init];
            log.startingOffset = touch.timestamp;
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
        [log addLocation:location atRelativeTime:touch.timestamp];
        
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
            FRYTouchEvent *event = [self.activeTouchLog objectForKey:touch];
            
            [self.delegate tracker:self recordEvent:event];
            [self.activeTouchLog removeObjectForKey:touch];
            [self.touchBeganOnViews removeObjectForKey:touch];
        }
    }
}

@end
