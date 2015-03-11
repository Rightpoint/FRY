//
//  FRYDefines.m
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYDefines.h"
#import "UIKit+FRYExposePrivate.h"

NSTimeInterval const kFRYEventDispatchInterval = 0.01;

@interface FRYAccessibilityEnabler : NSObject @end
@implementation FRYAccessibilityEnabler

+ (void)load
{
    @autoreleasepool {
        // The enableAccessibility command must be ran after UIApplicationMain has been started,
        // so wait for the notification
        __block id observer = nil;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            [[NSNotificationCenter defaultCenter] removeObserver:observer];
            [self enableAccessibility];
            observer = nil;
        }];
    }
}

+ (void)enableAccessibility;
{
    if ( ![UIView instancesRespondToSelector:@selector(_accessibilityElementsInContainer:)] ) {
        if ( [[[UIDevice currentDevice] model] rangeOfString:@"simulator"].location != NSNotFound ) {
            [[[UIApplication sharedApplication] _accessibilityBundlePrincipalClass] _accessibilityStartServer];
        }
        else {
            [[UIApplication sharedApplication] accessibilityActivate];
        }
    }
}

@end