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


@interface NSObject(FRYTestStub)
- (void) recordFailureWithDescription:(NSString *) description inFile:(NSString *) filename atLine:(NSUInteger) lineNumber expected:(BOOL) expected;
@end


@interface FRYAction () <FRYLookup>

@property (assign, nonatomic) BOOL firstOnly;
@property (strong, nonatomic) id<FRYLookup> lookupOrigin;

@property (strong, nonatomic) NSPredicate *predicate;
@property (assign, nonatomic) NSTimeInterval timeout;

@end

@implementation FRYAction

+ (FRYAction *)actionFrom:(id<FRYLookup>)lookupRoot
{
    FRYAction *action = [[FRYAction alloc] init];
    action.lookupOrigin = lookupRoot;
    action.timeout = 1.0;
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
        results = [self.lookupOrigin fry_allChildrenMatching:self.predicate];
    }
    else {
        id result = [self.lookupOrigin fry_farthestDescendentMatching:self.predicate];
        if ( result ) {
            results = [NSSet setWithObject:result];
        }
    }
    return results;
}

- (FRYAction *)actionByAddingPredicate:(NSPredicate *)predicate
{
    FRYAction *action = self;
    if ( action.predicate != nil ) {
        action = [FRYAction actionFrom:self];
    }
    action.predicate = predicate;
    return action;
}

- (FRYChainBlock)lookup
{
    return ^(NSPredicate *predicate) {
        self.firstOnly = NO;
        return [self actionByAddingPredicate:predicate];
    };
}

- (FRYChainBlock)lookupFirst
{
    return ^(NSPredicate *predicate) {
        self.firstOnly = YES;
        return [self actionByAddingPredicate:predicate];
    };
}

#pragma mark - Check

- (FRYCountBlock)count
{
    return ^(NSUInteger count) {
        __block NSSet *results = nil;
        BOOL isOK = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:self.timeout forCheck:^BOOL{
            results = [self results];
            return results.count == count;
        }];
        if ( isOK == NO ) {
            [self failWithMessage:[NSString stringWithFormat:@"Looking for %zd elements, found %zd", count, results.count] results:results];
        }
        return isOK;
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

- (FRYTouchBlock)touch
{
    return ^(id touchOrArrayOfTouches) {
        self.firstOnly = YES;
        __block NSSet *results = nil;
        BOOL isOK = [[NSRunLoop currentRunLoop] fry_waitWithTimeout:self.timeout forCheck:^BOOL{
            results = [self results];
            return results.count == 1;
        }];

        if ( isOK ) {
            id<FRYLookup> result = [results anyObject];

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

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p origin=%@, predicate=%@", self.class, self, self.lookupOrigin, self.predicate];
}

@end
