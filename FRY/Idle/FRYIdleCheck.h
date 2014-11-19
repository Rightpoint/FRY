//
//  FRYIdleCheck.h
//  FRY
//
//  Created by Brian King on 11/17/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRYIdleCheck : NSObject

+ (FRYIdleCheck *)system;

+ (void)setupSystemChecks:(NSArray *)checks;

- (BOOL)isIdle;

- (NSString *)busyDescription;

@property (assign, nonatomic) NSTimeInterval timeout;

- (BOOL)waitForIdle;

@end
