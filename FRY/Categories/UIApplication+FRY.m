//
//  UIApplication+FRY.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIApplication+FRY.h"
#import "UIKit+FRYExposePrivate.h"
#import "FRYEventProxy.h"

#import "UIView+FRY.h"
#import "FRYLookupSupport.h"

@implementation UIApplication(FRY)

- (UIEvent *)fry_eventWithTouches:(NSArray *)touches
{
    UIEvent *event = [self _touchesEvent];
    
    UITouch *touch = touches[0];
    CGPoint location = [touch locationInView:touch.window];
    FRYEventProxy *eventProxy = [[FRYEventProxy alloc] init];
    eventProxy->x1 = location.x;
    eventProxy->y1 = location.y;
    eventProxy->x2 = location.x;
    eventProxy->y2 = location.y;
    eventProxy->x3 = location.x;
    eventProxy->y3 = location.y;
    eventProxy->sizeX = 1.0;
    eventProxy->sizeY = 1.0;
    eventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
    eventProxy->type = 3001;
    
    [event _clearTouches];
    [event _setGSEvent:(struct __GSEvent *)eventProxy];
    
    for (UITouch *aTouch in touches) {
        [event _addTouch:aTouch forDelayedDelivery:NO];
    }
    
    return event;
}

- (UIWindow *)fry_keyboardWindow
{
    for ( UIWindow *window in self.windows ) {
        if ( [window isKindOfClass:[UITextEffectsWindow class]] ) {
            return window;
        }
    }
    return nil;
}

- (UIView *)fry_animatingViewToWaitFor
{
    __block UIView *animatingView = nil;
    for ( UIWindow *window in self.windows ) {
        UIView *animatingViewInWindow = [window fry_animatingViewToWaitFor];
        if ( animatingViewInWindow ) {
            animatingView = animatingViewInWindow;
            break;
        }
    }
    return animatingView;
}


@end
