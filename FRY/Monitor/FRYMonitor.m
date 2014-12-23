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
#import "FRYEventLog.h"

@interface FRYMonitor() <FRYTrackerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) FRYTouchTracker *tracker;
@property (strong, nonatomic) FRYTouchHighlightWindowLayer *highlightLayer;

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
    [self.highlightLayer showString:@"Recording Enabled"];
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
                                                 name:UIApplicationWillEnterForegroundNotification
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
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [self.tracker disable];
    [self.highlightLayer disable];
    [self printTouchLog];
    self.recordGestureRecognizer.enabled = YES;
    self.presentUIGestureRecognizer.enabled = YES;
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Save Event Log"
                                                 message:@"Enter Log Name"
                                                delegate:self
                                       cancelButtonTitle:@"Cancel"
                                       otherButtonTitles:@"Save", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex != alertView.cancelButtonIndex ) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self saveEventLogWithName:textField.text];
    }
    else {
        [self clearEventLog];
    }
}

- (void)saveEventLogWithName:(NSString *)eventLogName
{
    FRYEventLog *log = [[FRYEventLog alloc] init];
    log.name = eventLogName;
    log.startingDate = [NSDate date];
    log.events = self.activeEvents;
    NSError *error = nil;
    if ( [log save:&error] == NO ) {
        [[[UIAlertView alloc] initWithTitle:@"Error Saving Log"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
    [self clearEventLog];
}

- (void)clearEventLog
{
    self.activeEvents = nil;
}

- (void)printTouchLog
{
    for ( FRYEvent *event in self.activeEvents ) {
        printf("%s\n", [[event recreationCode] UTF8String]);
    }
}


@end
