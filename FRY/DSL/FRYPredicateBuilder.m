//
//  FRYPredicateBuilder.m
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "FRYPredicateBuilder.h"
#import "NSPredicate+FRY.h"

@interface FRYPredicatePart ()

@property (copy, nonatomic) NSString *keyPath;
@property (assign, nonatomic) BOOL notFlag;
@property (assign, nonatomic) BOOL caseSensitiveFlag;

@end

@implementation FRYPredicatePart

+ (FRYPredicatePart *)partForKeyPath:(NSString *)keypath
{
    FRYPredicatePart *part = [[FRYPredicatePart alloc] init];
    part.keyPath = keypath;
    return part;
}


- (FRYPredicateObjectComparison)equalTo
{
    return ^(id value) {
        return [NSPredicate predicateWithFormat:@"%K = %@", self.keyPath, value];
    };
}

- (FRYPredicateFlip)not
{
    return ^() {
        self.notFlag = YES;
        return self;
    };
}

- (FRYPredicateFlip)caseSensitive
{
    return ^() {
        self.caseSensitiveFlag = YES;
        return self;
    };
}

- (NSString *)caseSensitiveString
{
    return self.caseSensitive ? @"" : @"[cd]";
}

- (NSPredicate *)predicateWithFormat:(NSString *)format values:(NSArray *)values
{
    if ( self.notFlag ) {
        format = [NSString stringWithFormat:@"!(%@)", format];
    }
    return [NSPredicate predicateWithFormat:format argumentArray:values];
}

- (FRYPredicateObjectComparison)like
{
    return ^(id value) {
        return [self predicateWithFormat:@"%K LIKE%@ %@" values:@[self.keyPath, self.caseSensitiveString, value]];
    };
}

- (FRYPredicateObjectComparison)matches
{
    return ^(id value) {
        return [self predicateWithFormat:@"%K MATCHES%@ %@" values:@[self.keyPath, self.caseSensitiveString, value]];
    };
}

- (FRYPredicateObjectComparison)beginsWith
{
    return ^(id value) {
        return [self predicateWithFormat:@"%K BEGINSWITH%@ %@" values:@[self.keyPath, self.caseSensitiveString, value]];
    };
}

- (FRYPredicateObjectComparison)endsWith
{
    return ^(id value) {
        return [self predicateWithFormat:@"%K ENDSWITH%@ %@" values:@[self.keyPath, self.caseSensitiveString, value]];
    };
}

- (FRYPredicateObjectComparison)lt
{
    return ^(id value) {
        NSAssert(self.caseSensitiveFlag == NO, @"Comparison does not support case");
        return [self predicateWithFormat:@"%K < %@" values:@[self.keyPath, value]];
    };
}

- (FRYPredicateObjectComparison)lte
{
    return ^(id value) {
        NSAssert(self.caseSensitiveFlag == NO, @"Comparison does not support case");
        return [self predicateWithFormat:@"%K <= %@" values:@[self.keyPath, value]];
    };
}

- (FRYPredicateObjectComparison)gt
{
    return ^(id value) {
        NSAssert(self.caseSensitiveFlag == NO, @"Comparison does not support case");
        return [self predicateWithFormat:@"%K > %@" values:@[self.keyPath, value]];
    };
}

- (FRYPredicateObjectComparison)gte
{
    return ^(id value) {
        NSAssert(self.caseSensitiveFlag == NO, @"Comparison does not support case");
        return [self predicateWithFormat:@"%K >= %@" values:@[self.keyPath, value]];
    };
}

- (FRYPredicateIntComparison)withFlags
{
    return ^(NSUInteger flags) {
        NSAssert(self.caseSensitiveFlag == NO, @"Comparison does not support case");
        return [self predicateWithFormat:@"(%K & %@) = &@" values:@[self.keyPath, @(flags), @(flags)]];
    };
}

@end
