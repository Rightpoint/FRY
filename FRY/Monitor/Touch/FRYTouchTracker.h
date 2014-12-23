//
//  FRYEventMonitor.h
//  FRY
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYTracker.h"


/**
 * This object records application interaction.   It will generate a log of object
 */
@interface FRYTouchTracker : FRYTracker

- (void)trackEvent:(UIEvent *)event;

@end
