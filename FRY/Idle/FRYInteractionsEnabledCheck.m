//
//  FRYInteractionsEnabledCheck.m
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYInteractionsEnabledCheck.h"

@implementation FRYInteractionsEnabledCheck : FRYIdleCheck

- (BOOL)isIdle
{
    return [[UIApplication sharedApplication] isIgnoringInteractionEvents] == NO;
}

- (NSString *)busyDescription
{
    return @"UIApplication is ignoring interaction events";
}

@end

