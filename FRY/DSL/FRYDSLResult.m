//
//  FRYDSLResult.m
//  FRY
//
//  Created by Brian King on 11/14/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//
#import "UIApplication+FRY.h"
#import "UIView+FRY.h"
#import "UITextInput+FRY.h"

#import "FRYDSLResult.h"
#import "FRYTypist.h"

static BOOL pauseOnFailure = NO;

@interface NSObject(FRYTestStub)

- (void) recordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected;

@end

@interface FRYDSLResult()

@property (strong, nonatomic) FRYDSLQuery *query;
@property (copy, nonatomic) NSSet *results;

@end

@implementation FRYDSLResult

+ (void)setPauseForeverOnFailure:(BOOL)pause;
{
    pauseOnFailure = pause;
}

- (id)initWithResults:(NSSet *)results query:(FRYDSLQuery *)query
{
    self = [super init];
    if ( self ) {
        self.query = query;
        self.results = results;
    }
    return self;
}

- (id<FRYLookup>)singularResult
{
    [self check:self.results.count == 1 explaination:[NSString stringWithFormat:@"Only expected 1 lookup result, found %zd", self.results.count]];
    return self.results.anyObject;
}

- (void)check:(BOOL)result explaination:(NSString *)explaination
{
    NSParameterAssert(explaination);
    // Easily add support for other frameworks by messaging failures here.
    NSAssert([self.query.testTarget respondsToSelector:@selector(recordFailureWithDescription:inFile:atLine:expected:)], @"Called from a non test function.  Not sure how to perform checks.");
    if ( result == NO ) {
        explaination = [explaination stringByAppendingFormat:@"\nGot:%@\nLookup Origin:%@\nPredicate:%@\n",
                        self.results,
                        self.query.lookupOrigin,
                        self.query.predicate];
        [self.query.testTarget recordFailureWithDescription:explaination inFile:self.query.filename atLine:self.query.lineNumber expected:YES];
        while ( pauseOnFailure ) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    }
}

- (FRYDSLBlock)present
{
    return ^() {
        [self singularResult];
        return self;
    };
}

- (FRYDSLBlock)absent
{
    return ^() {
        [self check:self.results.count == 0 explaination:[NSString stringWithFormat:@"Expected 0 lookup results to be present, found %zd", self.results.count]];
        return self;
    };
}

- (FRYDSLIntegerBlock) count
{
    return ^(NSInteger count) {
        [self check:self.results.count == count explaination:[NSString stringWithFormat:@"Expected %zd lookup results to be present, found %zd", count, self.results.count]];
        return self;
    };
}

- (FRYDSLBlock)tap
{
    return ^() {
        UIView *view = [[self.singularResult fry_representingView] fry_interactableParent];
        CGRect frameInView = [self.singularResult fry_frameInView];
        [view fry_simulateTouch:[FRYTouch tap] insideRect:frameInView];
        return self;
    };
}

- (FRYDSLTouchBlock)touch
{
    return ^(FRYTouch *touch) {
        NSParameterAssert(touch);
        UIView *view = [[self.singularResult fry_representingView] fry_interactableParent];
        CGRect frameInView = [self.singularResult fry_frameInView];
        [view fry_simulateTouch:touch insideRect:frameInView];
        return self;
    };
}

- (FRYDSLArrayBlock)touches
{
    return ^(NSArray *touches) {
        NSParameterAssert(touches);
        UIView *view = [[self.singularResult fry_representingView] fry_interactableParent];
        CGRect frameInView = [self.singularResult fry_frameInView];
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
        [self check:view != nil explaination:[NSString stringWithFormat:@"Could not find superview of %@ to select text of.", [self view]]];

        [(UITextField *)view fry_selectAll];
        return self;
    };
}

- (UIView *)view
{
    return [[self singularResult] fry_representingView];
}

- (void)onEach:(FRYMatchBlock)matchBlock
{
    NSParameterAssert(matchBlock);
    for ( id<FRYLookup> lookup in self.results ) {
        matchBlock([lookup fry_representingView], [lookup fry_frameInView]);
    }
}

@end
