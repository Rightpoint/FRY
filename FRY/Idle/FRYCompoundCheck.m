//
//  FRYCompoundCheck.m
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYCompoundCheck.h"

@implementation FRYCompoundCheck : FRYIdleCheck

- (instancetype)initWithChecks:(NSArray *)checks;
{
    self = [super init];
    if ( self ) {
        _checks = checks;
    }
    return self;
}

- (BOOL)isIdle
{
    BOOL isIdle = YES;
    for ( FRYIdleCheck *check in self.checks ) {
        if ( [check isIdle] == NO ) {
            isIdle = NO;
        }
    }
    return isIdle;
}

- (NSString *)busyDescription
{
    NSMutableString *busyDescription = [NSMutableString string];
    for ( FRYIdleCheck *check in self.checks ) {
        if ( [check isIdle] == NO ) {
            [busyDescription appendString:[check busyDescription]];
        }
    }
    return [busyDescription copy];
}

@end

