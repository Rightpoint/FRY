//
//  FRYTouchMonitor.m
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYTouchMonitor.h"
#import "FRYMethodSwizzling.h"
#import "FRYTouchRecorder.h"
#import "FRYTouchHighlightWindowLayer.h"

@implementation FRYTouchMonitor

- (void)enable
{
    [FRYMethodSwizzling exchangeClass:[UIApplication class]
                               method:@selector(sendEvent:)
                            withClass:[self class]
                               method:@selector(fry_sendEvent:)];
}

- (void)disable
{
    [FRYMethodSwizzling exchangeClass:[UIApplication class]
                               method:@selector(sendEvent:)
                            withClass:[self class]
                               method:@selector(fry_sendEvent:)];
}

- (void)fry_sendEvent:(UIEvent *)event
{
    [self fry_sendEvent:event];
    [[FRYTouchRecorder shared] recordEvent:event];
    [[FRYTouchHighlightWindowLayer touchHighlightWindow] visualizeEvent:event];
}

@end
