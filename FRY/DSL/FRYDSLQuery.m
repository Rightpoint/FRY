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
#import "NSRunLoop+FRY.h"
#import "UITextInput+FRY.h"

#import "FRYDSLQuery.h"
#import "NSObject+FRYLookup.h"

@interface NSObject(FRYTestStub)

- (void) recordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected;

@end

typedef NS_ENUM(NSInteger, FRYDSLQueryType) {
    FRYDSLQueryTypeDepthFirst,
    FRYDSLQueryTypeAll
};

@interface FRYDSLQuery()

@property (strong, nonatomic) NSString *checkDescription;
@property (strong, nonatomic) id testTarget;
@property (copy,   nonatomic) NSString *filename;
@property (assign, nonatomic) NSUInteger lineNumber;
@property (strong, nonatomic) id<FRYLookup> lookupOrigin;
@property (strong, nonatomic) NSMutableArray *subPredicates;
@property (assign, nonatomic) FRYDSLQueryType queryType;

@property (copy, nonatomic) NSSet *results;

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
        self.timeout = 1.0;
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

- (FRYDSLIndexPathBlock)rowAtIndexPath
{
    return ^(NSIndexPath *indexPath) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:[UITableViewCell class]]];
        [self.subPredicates addObject:[NSPredicate fry_matchContainerIndexPath:indexPath]];
        return self;
    };
}

- (FRYDSLIndexPathBlock)itemAtIndexPath
{
    return ^(NSIndexPath *indexPath) {
        [self.subPredicates addObject:[NSPredicate fry_matchClass:[UICollectionViewCell class]]];
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

- (NSSet *)performQuery
{
    NSSet *results = nil;
    switch ( self.queryType ) {
        case FRYDSLQueryTypeDepthFirst: {
            id<FRYLookup> result = [self.lookupOrigin fry_farthestDescendentMatching:self.predicate];
            results = result ? [NSSet setWithObject:result] : [NSSet set];
            break;
        }
        case FRYDSLQueryTypeAll:
            results = [self.lookupOrigin fry_allChildrenMatching:self.predicate];
            break;
            
        default:
            break;
    }

    return results;
}

#pragma mark - Checking

- (BOOL)check:(FRYCheckBlock)check
{
    // Easily add support for other frameworks by messaging failures here.
    NSAssert([self.testTarget respondsToSelector:@selector(recordFailureWithDescription:inFile:atLine:expected:)], @"Called from a non test function.  Not sure how to perform checks.");
    
    BOOL isOK = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:self.timeout forCheck:^BOOL{
        self.results = [self performQuery];
        return check();
    }];
    
    if ( self.timeout == 0 ) {
        self.results = [self performQuery];
        isOK = check();
    }
    
    if ( isOK ) {
        NSLog(@"%@ for query %@ on %@ returned %@\n",
              self.checkDescription,
              self.predicate,
              self.lookupOrigin,
              self.results);
    }
    else {
        NSString *explaination = [NSString stringWithFormat:@"%@ failed\nGot:%@\nLookup Origin:%@\nPredicate:%@\n",
                                  self.checkDescription,
                                  self.results,
                                  self.lookupOrigin,
                                  self.predicate];
        [self.testTarget recordFailureWithDescription:explaination inFile:self.filename atLine:self.lineNumber expected:YES];
    }
    return isOK;
}

- (id<FRYLookup>)singularResult
{
    self.checkDescription = @"Only one result";
    [self check:^BOOL{return self.results.count == 1;}];
    return self.results.anyObject;
}

- (FRYDSLBlock)present
{
    return ^() {
        self.queryType = FRYDSLQueryTypeDepthFirst;
        [self singularResult];
        return self;
    };
}

- (FRYDSLBlock)absent
{
    return ^() {
        return self.count(0);
    };
}

- (FRYDSLIntegerBlock)count
{
    return ^(NSInteger count) {
        self.queryType = FRYDSLQueryTypeAll;
        self.checkDescription = [NSString stringWithFormat:@"Result Count is %zd", count];
        [self check:^BOOL{return self.results.count == count;}];
        return self;
    };
}

- (FRYDSLTimeIntervalBlock)waitFor
{
    return ^(NSTimeInterval timeout) {
        self.timeout = timeout;
        return self;
    };
}

- (FRYDSLBlock)tap
{
    return ^() {
        self.queryType = FRYDSLQueryTypeDepthFirst;
        id<FRYLookup> lookup = [self singularResult];
        UIView *view = [[lookup fry_representingView] fry_interactableParent];
        CGRect frameInView = [lookup fry_frameInView];
        [view fry_simulateTouch:[FRYTouch tap] insideRect:frameInView];
        return self;
    };
}

- (FRYDSLTouchBlock)touch
{
    return ^(FRYTouch *touch) {
        self.queryType = FRYDSLQueryTypeDepthFirst;
        NSParameterAssert(touch);
        id<FRYLookup> lookup = [self singularResult];
        UIView *view = [[lookup fry_representingView] fry_interactableParent];
        CGRect frameInView = [lookup fry_frameInView];
        [view fry_simulateTouch:touch insideRect:frameInView];
        return self;
    };
}

- (FRYDSLTouchesBlock)touches
{
    return ^(NSArray *touches) {
        NSParameterAssert(touches);
        id<FRYLookup> lookup = [self singularResult];
        UIView *view = [[lookup fry_representingView] fry_interactableParent];
        CGRect frameInView = [lookup fry_frameInView];
        [view fry_simulateTouches:touches insideRect:frameInView];
        return self;
    };
}

- (FRYDSLBlock)selectText
{
    return ^() {
        UIView *view = [self view];
        while ( view && [view respondsToSelector:@selector(fry_selectAll)] == NO ) {
            view = [view superview];
        }
        self.checkDescription = [NSString stringWithFormat:@"Could not find superview of %@ to select text of.", [self view]];
        [self check:^BOOL{return view != nil;}];
        
        [(UITextField *)view fry_selectAll];
        return self;
    };
}

- (UIView *)view
{
    return [[self singularResult] fry_representingView];
}

- (FRYDSLQuery *)subQuery
{
    return [[FRYDSLQuery alloc] initForLookup:self.view withTestTarget:self.testTarget inFile:self.filename atLine:self.lineNumber];
}

- (void)onEach:(FRYMatchBlock)matchBlock
{
    NSParameterAssert(matchBlock);
    for ( id<FRYLookup> lookup in self.results ) {
        matchBlock([lookup fry_representingView], [lookup fry_frameInView]);
    }
}

@end

