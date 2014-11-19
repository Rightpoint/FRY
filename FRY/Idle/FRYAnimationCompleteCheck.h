//
//  FRYAnimationCompleteCheck.h
//  FRY
//
//  Created by Brian King on 11/18/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYIdleCheck.h"

@interface FRYAnimationCompleteCheck : FRYIdleCheck

+ (void)addIgnorePredicate:(NSPredicate *)predicate;
+ (void)clearIgnorePredicates;

@end
