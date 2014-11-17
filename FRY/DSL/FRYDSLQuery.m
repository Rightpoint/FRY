//
//  FRYDSL.m
//  FRY
//
//  Created by Brian King on 11/14/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIApplication+FRY.h"
#import "UIView+FRY.h"
#import "NSPredicate+FRY.h"

#import "FRYDSLQuery.h"
#import "NSObject+FRYLookup.h"
#import "FRYDSLResult.h"

@interface FRYDSLQuery()

@property (strong, nonatomic) id testTarget;
@property (copy,   nonatomic) NSString *filename;
@property (assign, nonatomic) NSUInteger lineNumber;
@property (strong, nonatomic) id<FRYLookup> lookupOrigin;
@property (strong, nonatomic) NSMutableArray *subPredicates;

@end

@implementation FRYDSLQuery

- (id)initForLookup:(id<FRYLookup>)lookupOrigin withTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;
{
    self = [super init];
    if ( self ) {
        self.testTarget = target;
        self.filename = filename;
        self.lineNumber = lineNumber;
        self.subPredicates = [NSMutableArray array];
        self.lookupOrigin = lookupOrigin;
    }
    return self;
}

- (NSPredicate *)predicate
{
    return [NSCompoundPredicate andPredicateWithSubpredicates:self.subPredicates];
}

- (FRYDSLStringBlock)accessibilityLabel
{
    return ^(NSString *accessibilityLabel) {
        [self.subPredicates addObject:[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel]];
        return self;
    };
}

- (FRYDSLStringBlock)accessibilityValue
{
    return ^(NSString *accessibilityValue) {
        [self.subPredicates addObject:[NSPredicate fry_matchAccessibilityValue:accessibilityValue]];
        return self;
    };
}

- (FRYDSLTraitsBlock)accessibilityTraits
{
    return ^(UIAccessibilityTraits traits) {
        [self.subPredicates addObject:[NSPredicate fry_matchAccessibilityTrait:traits]];
        return self;
    };
}

- (FRYDSLClassBlock)ofClass
{
    return ^(Class klass) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:klass]];
        return self;
    };
}

- (FRYDSLIndexPathBlock)atIndexPath
{
    return ^(NSIndexPath *indexPath) {
        [self.subPredicates addObject:[NSPredicate fry_matchContainerIndexPath:indexPath]];
        return self;
    };
}

- (FRYDSLPredicateBlock)matching
{
    return ^(NSPredicate *predicate) {
        [self.subPredicates addObject:predicate];
        return self;
    };
}

- (FRYDSLBlock)all
{
    return ^() {
        NSSet *results = [self.lookupOrigin fry_allChildrenMatching:self.predicate];
        return [[FRYDSLResult alloc] initWithResults:results query:self];
    };
}

- (FRYDSLBlock)depthFirst
{
    return ^() {
        id<FRYLookup> result = [self.lookupOrigin fry_farthestDescendentMatching:self.predicate];
        NSSet *results = result ? [NSSet setWithObject:result] : [NSSet set];
        return [[FRYDSLResult alloc] initWithResults:results query:self];
    };
}

@end

