//
//  FRYDSL.m
//  FRY
//
//  Created by Brian King on 11/14/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYDSL.h"
#import "UIApplication+FRY.h"
#import "UIView+FRY.h"
#import "NSObject+FRYLookup.h"
#import "NSPredicate+FRY.h"
#import "FRYDSLResult.h"

@interface FRYDSL()

@property (strong, nonatomic) id testTarget;
@property (copy,   nonatomic) NSString *filename;
@property (assign, nonatomic) NSUInteger lineNumber;
@property (strong, nonatomic) id<FRYLookup> lookupOrigin;
@property (strong, nonatomic) NSMutableArray *subPredicates;
@property (copy, nonatomic) FRYMatchBlock block;

@end

@implementation FRYDSL

- (id)initForAppWithTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber
{
    self = [super init];
    if ( self ) {
        self.testTarget = target;
        self.filename = filename;
        self.lineNumber = lineNumber;
        self.subPredicates = [NSMutableArray array];
        self.lookupOrigin = [UIApplication sharedApplication];
    }
    return self;
}

- (id)initForKeyWindowWithTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber
{
    self = [super init];
    if ( self ) {
        self.testTarget = target;
        self.filename = filename;
        self.lineNumber = lineNumber;
        self.subPredicates = [NSMutableArray array];
        self.lookupOrigin = [[UIApplication sharedApplication] keyWindow];
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

- (FRYDSLClassBlock)ofClass
{
    return ^(Class klass) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:klass]];
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
        NSArray *results = [self.lookupOrigin fry_allChildrenMatching:self.predicate];
        return [[FRYDSLResult alloc] initWithResults:results testCase:self.testTarget inFile:self.filename atLine:self.lineNumber];
    };
}

- (FRYDSLBlock)depthFirst
{
    return ^() {
        id<FRYLookup> result = [self.lookupOrigin fry_farthestDescendentMatching:self.predicate];
        NSArray *results = result ? @[result] : @[];
        return [[FRYDSLResult alloc] initWithResults:results testCase:self.testTarget inFile:self.filename atLine:self.lineNumber];
    };
}

@end

