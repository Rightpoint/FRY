//
//  FRYolatorUI.m
//  FRYolator
//
//  Created by Brian King on 3/2/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "FRYolatorUI.h"

#import "FRYolator.h"

@interface FRYolatorUI () <FRYolatorDelegate>

@property (strong, nonatomic) UIGestureRecognizer *recordGestureRecognizer;

@end

@implementation FRYolatorUI

+ (FRYolatorUI *)shared
{
    static FRYolatorUI *fryolatorUI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fryolatorUI = [[FRYolatorUI alloc] init];
    });
    return fryolatorUI;
}

- (void)registerGestureEnablingOnView:(UIView *)view
{
    UITapGestureRecognizer *recordGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRecording:)];
    recordGR.numberOfTouchesRequired = 2;
    recordGR.numberOfTapsRequired = 3;
    [view addGestureRecognizer:recordGR];
    self.recordGestureRecognizer = recordGR;

    FRYolator.shared.delegate = self;
}

- (void)toggleRecording:(UIGestureRecognizer *)gr
{
    // Touch must finish before starting the recording, so enable in the next runloop
    [[NSOperationQueue currentQueue] addOperationWithBlock:^{
        if ( FRYolator.shared.enabled ) {
            NSError *error = nil;
            if ( [FRYolator.shared saveEventLogNamed:@"LastFryLog" error:&error] == NO ) {
                [[[UIAlertView alloc] initWithTitle:@"Error Saving Log"
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }

            [FRYolator.shared disable];
            NSLog(@"Note the 2 finger triple tap is included in the log, and should probably be ignored.");
        }
        else {
            [FRYolator.shared enable];
        }
    }];
}

@end
