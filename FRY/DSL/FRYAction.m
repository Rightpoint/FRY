//
//  FRYActionBuilder.m
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "FRYAction.h"
#import "NSRunLoop+FRY.h"
#import "FRYTouch.h"
#import "FRYTouchDispatch.h"
#import "NSPredicate+FRY.h"
#import "UIScrollView+FRY.h"
#import "UITextInput+FRY.h"

@interface NSObject(FRYTestStub)
- (void) recordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected;
@end

static NSTimeInterval FRYActionDefaultTimeout = 1.0;

@interface FRYAction () <FRYLookup>

@property (assign, nonatomic) BOOL firstOnly;
@property (strong, nonatomic) id<FRYLookup> lookupOrigin;
@property (strong, nonatomic) FRYActionContext *context;

@property (strong, nonatomic) NSPredicate *predicate;
@property (assign, nonatomic) NSTimeInterval timeout;

@end

@implementation FRYAction

+ (void)setDefaultTimeout:(NSTimeInterval)timeout
{
    FRYActionDefaultTimeout = timeout;
}

+ (FRYAction *)actionFrom:(id<FRYLookup>)lookupRoot context:(FRYActionContext *)context
{
    FRYAction *action = [[FRYAction alloc] init];
    action.lookupOrigin = lookupRoot;
    action.timeout = FRYActionDefaultTimeout;
    action.context = context;
    return action;
}

#pragma mark - Lookup

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:NSStringFromSelector(@selector(results))];
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

- (FRYAction *)actionByAddingPredicate:(NSPredicate *)predicate
{
    FRYAction *action = self;
    if ( action.predicate != nil ) {
        action = [FRYAction actionFrom:self context:self.context];
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

- (FRYChainBlock)lookup
{
    return ^(id predicateOrArray) {
        self.firstOnly = NO;
        return [self actionByAddingPredicate:[self predicateFromPredicateOrArray:predicateOrArray]];
    };
}

- (FRYChainBlock)lookupFirst
{
    return ^(id predicateOrArray) {
        self.firstOnly = YES;
        return [self actionByAddingPredicate:[self predicateFromPredicateOrArray:predicateOrArray]];
    };
}

- (FRYChainStringBlock)lookupFirstByAccessibilityLabel
{
    return ^(NSString *accessibilityLabel) {
        self.firstOnly = YES;
        NSArray *subPredicates = @[[NSPredicate fry_matchAccessibilityLabel:accessibilityLabel],
                                   [NSPredicate fry_isVisible],
                                   [NSPredicate fry_isOnScreen]];

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

- (FRYBoolCheckBlock)absent
{
    return ^() {
        return self.count(0);
    };
}

- (FRYBoolCheckBlock)present
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

- (FRYBoolCheckBlock)tap
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
                                                 frame:[result fry_frameInView]];
        }
        return isOK;
    };
}

- (FRYDirectionBlock)searchFor
{
    return ^(FRYDirection direction, NSPredicate *scrollToVisible) {
        FRYAction *action = [self actionByAddingPredicate:[NSPredicate fry_matchClass:[UIScrollView class]]];
        action.firstOnly = YES;
        BOOL success = action.check(@"Looking for the a UIScrollView subclass", ^(NSSet *results) {
            BOOL ok = results.count == 1;
            return ok;
        });
        if ( success ) {
            UIScrollView *scrollView = [[action results] anyObject];
            success = [scrollView fry_searchForViewsMatching:scrollToVisible lookInDirection:direction];
        }
        return success;
    };
}

- (FRYSearchBlock)scrollTo
{
    return ^(NSPredicate *scrollToVisible) {
        FRYAction *action = [self actionByAddingPredicate:[NSPredicate fry_matchClass:[UIScrollView class]]];
        action.firstOnly = YES;
        BOOL success = action.check(@"Looking for the a UIScrollView subclass", ^(NSSet *results) {
            BOOL ok = results.count == 1;
            return ok;
        });
        if ( success ) {
            UIScrollView *scrollView = [[action results] anyObject];
            success = [scrollView fry_scrollToLookupResultMatching:scrollToVisible];
        }
        return success;
    };
}

- (FRYBoolCheckBlock)selectText
{
    return ^() {
        NSArray *subPredicates = @[[NSPredicate fry_matchClass:[UITextField class]],
                                   [NSPredicate fry_matchClass:[UITextView class]]];
        NSPredicate *textClass = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        FRYAction *action = [self actionByAddingPredicate:textClass];
        action.firstOnly = YES;
        BOOL success = action.check(@"Looking for a text field", ^(NSSet *results) {
            BOOL ok = results.count == 1;
            return ok;
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
