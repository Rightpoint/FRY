//
//  FRYCompoundCheck.h
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYIdleCheck.h"

@interface FRYCompoundCheck : FRYIdleCheck

- (instancetype)initWithChecks:(NSArray *)checks;

@property (strong, nonatomic, readonly) NSArray *checks;

@end
