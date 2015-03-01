//
//  FRYTouchMonitor.m
//  FRY
//
//  Created by Brian King on 12/20/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYolator.h"

#import "FRYEventLog.h"

#import "FRYTouchTracker.h"
#import "FRYNetworkTracker.h"

#import "FRYTouchHighlightWindowLayer.h"
#import "FRYMethodSwizzling.h"

@interface FRYolator() <FRYTrackerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) FRYTouchTracker *touchTracker;
@property (strong, nonatomic) FRYNetworkTracker *networkTracker;

@property (strong, nonatomic) FRYTouchHighlightWindowLayer *highlightLayer;

@property (strong, nonatomic) UITapGestureRecognizer *recordGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *presentUIGestureRecognizer;

@property (assign, nonatomic) BOOL enabled;
@property (strong, nonatomic) FRYEventLog *eventLog;

@end

@implementation FRYolator

+ (FRYolator *)shared
{
    static FRYolator *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [FRYMethodSwizzling exchangeClass:[UIApplication class]
                                   method:@selector(sendEvent:)
                                withClass:[self class]
                                   method:@selector(fry_sendEvent:)];

        monitor = [[FRYolator alloc] init];
    });
    return monitor;
}

- (instancetype)init
{
    self = [super init];
    if ( self ) {
        self.touchTracker = [[FRYTouchTracker alloc] initWithDelegate:self];
        self.networkTracker = [[FRYNetworkTracker alloc] initWithDelegate:self];
        self.highlightLayer = [[FRYTouchHighlightWindowLayer alloc] init];
    }
    return self;
}

- (void)enable
{
    self.eventLog = [[FRYEventLog alloc] init];
    if ( [self.delegate respondsToSelector:@selector(appSchemeURLRepresentingCurrentStateForFryolator:)] ) {
        self.eventLog.appSchemeURL = [self.delegate appSchemeURLRepresentingCurrentStateForFryolator:self];
    }

    [self.touchTracker enable];
    [self.networkTracker enable];
    [self.highlightLayer enable];
    self.enabled = YES;
}

- (void)disable
{
    [self.touchTracker disable];
    [self.networkTracker disable];
    [self.highlightLayer disable];
    self.enabled = NO;
}

- (void)clearState
{
    self.eventLog = nil;
}

- (void)fry_sendEvent:(UIEvent *)event
{
    [self fry_sendEvent:event];
    if ( FRYolator.shared.enabled ) {
        [FRYolator.shared.touchTracker trackEvent:event];
        [FRYolator.shared.highlightLayer visualizeEvent:event];
    }
}

- (void)tracker:(FRYTracker *)tracker recordEvent:(FRYEvent *)event
{
    [self.eventLog addEvent:event];
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
        [self enable];
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
    NSLog(@"\n%@", [self.eventLog commandsToReproduce]);
    self.recordGestureRecognizer.enabled = YES;
    self.presentUIGestureRecognizer.enabled = YES;

    [self disable];
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
    [self clearState];
}

- (void)saveEventLogWithName:(NSString *)eventLogName
{
    self.eventLog.name = eventLogName;
    NSError *error = nil;
    if ( [self.eventLog save:&error] == NO ) {
        [[[UIAlertView alloc] initWithTitle:@"Error Saving Log"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
