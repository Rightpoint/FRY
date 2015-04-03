//
//  FRYQueryBuilder.m
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "FRYQuery.h"
#import "NSRunLoop+FRY.h"
#import "FRYTouch.h"
#import "FRYTouchDispatch.h"
#import "NSPredicate+FRY.h"
#import "UIScrollView+FRY.h"
#import "UITextInput+FRY.h"
#import "UIAccessibility+FRY.h"

@interface NSObject(FRYTestStub)
- (void) recordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected;
@end

static NSTimeInterval FRYQueryDefaultTimeout = 1.0;

@interface FRYQuery () <FRYLookup>

@property (assign, nonatomic) BOOL firstOnly;
@property (strong, nonatomic) id<FRYLookup> lookupOrigin;
@property (strong, nonatomic) FRYTestContext *context;

@property (strong, nonatomic) NSPredicate *predicate;
@property (assign, nonatomic) NSTimeInterval timeout;

@end

@implementation FRYQuery

+ (void)setDefaultTimeout:(NSTimeInterval)timeout
{
    FRYQueryDefaultTimeout = timeout;
}

+ (FRYQuery *)queryFrom:(id<FRYLookup>)lookupRoot context:(FRYTestContext *)context
{
    FRYQuery *action = [[FRYQuery alloc] init];
    action.lookupOrigin = lookupRoot;
    action.timeout = FRYQueryDefaultTimeout;
    action.context = context;
    return action;
}

#pragma mark - Lookup

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:FRY_KEYPATH(FRYQuery, results)];
}

- (NSSet *)results
{
    NSSet *results = nil;
    if ( self.firstOnly ) {
        id result = [self.lookupOrigin fry_firstDescendentMatching:self.predicate];
        if ( result ) {
            results = [NSSet setWithObject:result];
        }
    }
    else {
        results = [self.lookupOrigin fry_allChildrenMatching:self.predicate];
    }
    return results;
}

- (FRYQuery *)actionByAddingPredicate:(NSPredicate *)predicate
{
    FRYQuery *action = self;
    if ( action.predicate != nil ) {
        action = [FRYQuery queryFrom:self context:self.context];
    }
    action.predicate = predicate;
    return action;
}

- (NSPredicate *)predicateFromPredicateOrArray:(id)predicateOrArray
{
    NSPredicate *predicate = nil;
    if ( [predicateOrArray isKindOfClass:[NSArray class]] ) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateOrArray];
    }
    else if ( [predicateOrArray isKindOfClass:[NSPredicate class]] ) {
        predicate = predicateOrArray;
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"Invalid argument '%@', must be a predicate or array", predicateOrArray];
    }
    return predicate;
}

- (FRYChainPredicateBlock)lookup
{
    return ^(id predicateOrArray) {
        self.firstOnly = NO;
        return [self actionByAddingPredicate:[self predicateFromPredicateOrArray:predicateOrArray]];
    };
}

- (FRYChainBlock)shallow
{
    return ^() {
        self.firstOnly = YES;
        return self;
    };
}

- (FRYChainStringBlock)lookupByAccessibilityLabel
{
    return ^(NSString *accessibilityLabel) {
        self.firstOnly = YES;
        NSArray *subPredicates = @[FRY_accessibilityLabel(accessibilityLabel),
                                   FRY_isAnimating(NO),
                                   FRY_isOnScreen(YES)];

        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
        return [self actionByAddingPredicate:predicate];
    };
}

#pragma mark - Check

- (FRYBoolCallbackBlock)check
{
    return ^(NSString *message, FRYBoolResultsBlock check) {
        __block NSSet *results = nil;
        BOOL isOK = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:self.timeout forCheck:^BOOL{
            results = [self results];
            return check(results);
        }];
        if ( isOK == NO ) {
            [self.context recordFailureWithMessage:message action:self results:results];
        }
        return isOK;
    };
}

- (FRYIntCheckBlock)count
{
    return ^(NSUInteger count) {
        NSString *message = [NSString stringWithFormat:@"Looking for %zd items", count];
        return self.check(message, ^(NSSet *results) {
            BOOL ok = results.count == count;
            return ok;
        });
    };
}

- (FRYCheckBlock)absent
{
    return ^() {
        return self.count(0);
    };
}

- (FRYCheckBlock)present
{
    return ^() {
        return self.count(1);
    };
}

- (NSArray *)views
{
    return [[self results] allObjects];
}

- (NSArray *)view
{
    return self.views.firstObject;
}

- (FRYCheckBlock)tap
{
    return ^() {
        return self.touch([FRYTouch tap]);
    };
}

- (FRYTouchBlock)touch
{
    return ^(id touchOrArrayOfTouches) {
        self.firstOnly = YES;
        BOOL isOK = self.check(@"Looking up view to tap", ^(NSSet *results) {
            BOOL ok = results.count == 1;
            return ok;
        });

        if ( isOK ) {
            id<FRYLookup> result = [[self results] anyObject];

            if ( [touchOrArrayOfTouches isKindOfClass:[FRYTouch class]] ) {
                touchOrArrayOfTouches = @[touchOrArrayOfTouches];
            }
            [[FRYTouchDispatch shared] simulateTouches:touchOrArrayOfTouches
                                                inView:[result fry_representingView]
                                                 frame:[result fry_frameInWindow]];
        }
        return isOK;
    };
}

- (FRYSearchBlock)searchFor
{
    return ^(FRYDirection direction, NSPredicate *scrollToVisible) {
        FRYQuery *action = [self actionByAddingPredicate:FRY_ofKind([UIScrollView class])];
        action.firstOnly = YES;
        BOOL success = action.check(@"Looking for the a UIScrollView subclass", ^(NSSet *results) {
            return (BOOL)(results.count == 1);
        });
        if ( success ) {
            UIScrollView *scrollView = [[action results] anyObject];
            success = [scrollView fry_searchForViewsMatching:scrollToVisible lookInDirection:direction];
        }
        return success;
    };
}

- (FRYLookupBlock)scrollTo
{
    return ^(NSPredicate *scrollToVisible) {
        FRYQuery *action = [self actionByAddingPredicate:FRY_ofKind([UIScrollView class])];
        action.firstOnly = YES;
        BOOL success = action.check(@"Looking for the a UIScrollView subclass", ^(NSSet *results) {
            return (BOOL)(results.count == 1);
        });
        if ( success ) {
            UIScrollView *scrollView = [[action results] anyObject];
            success = [scrollView fry_scrollToLookupResultMatching:scrollToVisible];
        }
        return success;
    };
}

- (FRYCheckBlock)selectText
{
    return ^() {
        NSArray *subPredicates = @[FRY_ofKind([UITextField class]),
                                   FRY_ofKind([UITextView class])];
        NSPredicate *textClass = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        FRYQuery *action = [self actionByAddingPredicate:textClass];
        action.firstOnly = YES;
        BOOL success = action.check(@"Looking for a text field", ^(NSSet *results) {
            return (BOOL)(results.count == 1);
        });
        if ( success ) {
            UITextField *textInput = [[action results] anyObject];
            [textInput fry_selectAll];
        }
        return success;
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p predicate='%@', origin=%@>", self.class, self, self.lookupOrigin, self.predicate];
}

@end
