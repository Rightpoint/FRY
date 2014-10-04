//
//  IDKVTreeLookup.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYKVTreeLookup.h"
@interface FRYKVTreeLookup()

@property (nonatomic, strong, readonly) NSArray *childKeyPaths;

@property (nonatomic, strong, readonly) NSPredicate *predicate;

@end

@implementation FRYKVTreeLookup

- (id)initWithChildKeyPaths:(NSArray *)childKeyPaths predicate:(NSPredicate *)predicate;
{
    self = [super init];
    if (self) {
        _childKeyPaths = childKeyPaths;
        _predicate = predicate;
    }
    return self;
}

- (NSArray *)lookForMatchingObjectsStartingFrom:(NSObject *)object
{
    NSMutableArray *results = [NSMutableArray array];
    [self lookForMatchingObjectsStartingFrom:object withMatches:results];
    return results;
}

- (void)lookForMatchingObjectsStartingFrom:(NSObject *)object withMatches:(NSMutableArray *)matches
{
    if ( [self.predicate evaluateWithObject:object] ) {
        [matches addObject:object];
    }
    for ( NSString *childKeyPath in self.childKeyPaths ) {
        NSArray *children = [object valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            [self lookForMatchingObjectsStartingFrom:child withMatches:matches];
        }
    }
}



@end
