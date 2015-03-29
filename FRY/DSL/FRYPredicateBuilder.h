//
//  FRYPredicateBuilder.h
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FRYDefines.h"

#define FRY_PREDICATE_PART(c, p) [FRYPredicatePart partForKeyPath:FRY_KEYPATH(c,p)]


@class FRYPredicatePart;

typedef NSPredicate*(^FRYPredicateObjectComparison)(id);
typedef NSPredicate*(^FRYPredicateIntComparison)(NSUInteger);
typedef FRYPredicatePart*(^FRYPredicateFlip)();

@interface FRYPredicatePart : NSObject

+ (FRYPredicatePart *)partForKeyPath:(NSString *)keypath;

@property (copy, nonatomic) FRYPredicateObjectComparison equalTo;
@property (copy, nonatomic) FRYPredicateObjectComparison like;
@property (copy, nonatomic) FRYPredicateObjectComparison matches;
@property (copy, nonatomic) FRYPredicateObjectComparison beginsWith;
@property (copy, nonatomic) FRYPredicateObjectComparison endsWith;

@property (copy, nonatomic) FRYPredicateFlip not;
@property (copy, nonatomic) FRYPredicateFlip caseSensitive;

@property (copy, nonatomic) FRYPredicateObjectComparison lt;
@property (copy, nonatomic) FRYPredicateObjectComparison lte;
@property (copy, nonatomic) FRYPredicateObjectComparison gt;
@property (copy, nonatomic) FRYPredicateObjectComparison gte;

@property (copy, nonatomic) FRYPredicateIntComparison withFlags;

@end
