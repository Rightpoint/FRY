//
//  FRYTouchMonitor.m
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYMonitor.h"
#import "FRYMethodSwizzling.h"
#import "FRYTouchTracker.h"
#import "FRYTouchHighlightWindowLayer.h"

@interface FRYMonitor() <FRYTrackerDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *recordGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *presentUIGestureRecognizer;
@property (strong, nonatomic) NSMutableArray *activeEvents;
@property (assign, nonatomic) NSTimeInterval enableTime;

@end

@implementation FRYMonitor

+ (void)load
{
    [self.shared enable];
}

+ (FRYMonitor *)shared
{
    static FRYMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[FRYMonitor alloc] init];
    });
    return monitor;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.tracker = [[FRYTouchTracker alloc] initWithDelegate:self];
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
    self.activeEvents = [NSMutableArray array];
    self.enableTime = [[NSProcessInfo processInfo] systemUptime];
}

- (void)disable
{
    [FRYMethodSwizzling exchangeClass:[UIApplication class]
                               method:@selector(sendEvent:)
                            withClass:[self class]
                               method:@selector(fry_sendEvent:)];
    self.activeEvents = nil;
    self.enableTime = MAXFLOAT;
}

- (void)fry_sendEvent:(UIEvent *)event
{
    [self fry_sendEvent:event];
    [FRYMonitor.shared.tracker trackEvent:event];
    [FRYMonitor.shared.highlightLayer visualizeEvent:event];
}

- (NSTimeInterval)startTimeForEvents
{
    return [[NSProcessInfo processInfo] systemUptime] - self.enableTime;
}

- (void)tracker:(FRYTracker *)tracker recordEvent:(FRYEvent *)event
{
    [self.activeEvents addObject:event];
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
        [self.tracker enable];
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
    [self.tracker disable];
    [self.highlightLayer disable];
    [self printTouchLog];
    self.recordGestureRecognizer.enabled = YES;
    self.presentUIGestureRecognizer.enabled = YES;
}

- (void)printTouchLog
{
    for ( FRYEvent *event in self.activeEvents ) {
        printf("%s\n", [[event recreationCode] UTF8String]);
    }
}


@end
