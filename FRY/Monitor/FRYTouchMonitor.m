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

@interface FRYTouchMonitor()

@property (strong, nonatomic) UITapGestureRecognizer *recordGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *presentUIGestureRecognizer;

@end

@implementation FRYTouchMonitor

+ (void)load
{
    [self.shared enable];
}

+ (FRYTouchMonitor *)shared
{
    static FRYTouchMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[FRYTouchMonitor alloc] init];
    });
    return monitor;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.recorder = [[FRYTouchRecorder alloc] init];
        self.highlightLayer = [[FRYTouchHighlightWindowLayer alloc] init];
    }
    return self;
}

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
    [FRYTouchMonitor.shared.recorder recordEvent:event];
    [FRYTouchMonitor.shared.highlightLayer visualizeEvent:event];
}

- (void)registerGestureEnablingOnView:(UIView *)view
{
    UITapGestureRecognizer *recordGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enableTouchRecordingUIAction:)];
    recordGR.numberOfTouchesRequired = 2;
    recordGR.numberOfTapsRequired = 3;
    [view addGestureRecognizer:recordGR];
    self.recordGestureRecognizer = recordGR;
    
    UITapGestureRecognizer *presentUIGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentTouchRecordingUI:)];
    presentUIGR.numberOfTouchesRequired = 2;
    presentUIGR.numberOfTapsRequired = 4;
    [view addGestureRecognizer:presentUIGR];
    self.presentUIGestureRecognizer = presentUIGR;
}

- (void)enableTouchRecordingUIAction:(UIGestureRecognizer *)gr
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(completeRecording)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    self.recordGestureRecognizer.enabled = NO;
    self.presentUIGestureRecognizer.enabled = NO;
    
    // Touch must finish before starting the recording, so enable in the next runloop
    [[NSOperationQueue currentQueue] addOperationWithBlock:^{
        [self.recorder enable];
        [self.highlightLayer enable];
    }];
}

- (void)presentTouchRecordingUI:(UIGestureRecognizer *)gr
{
    // TBD
}

- (void)completeRecording
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [self.recorder printTouchLog];
    [self.recorder disable];
    [self.highlightLayer disable];
    self.recordGestureRecognizer.enabled = YES;
    self.presentUIGestureRecognizer.enabled = YES;
}

@end
