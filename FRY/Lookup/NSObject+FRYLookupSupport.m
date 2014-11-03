//
//  NSObject+FRYLookupSupport.m
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSObject+FRYLookupSupport.h"
#import "FRYLookupResult.h"
#import "UIAccessibility+FRY.h"
#import "UIAccessibilityElement+FRY.h"
#import "FRYDefines.h"
#import "UIView+FRY.h"

@implementation NSObject(FRYLookupSupport)

+ (NSSet *)fry_childKeyPaths
{
    // A lookup can not work, since the NSObject extension does not allow us to obtain
    // the containing UIView.  Since NSObject is the only shared heritage between UIView and UIAccessibilityElement
    // support NSObject for the compilers sake, even though we can't do much here.
    NSAssert(NO, @"");
    return nil;
}

- (FRYLookupResult *)fry_lookupResult
{
    NSAssert(NO, @"");
    return nil;
}

- (void)fry_enumerateDepthFirstViewMatching:(NSPredicate *)predicate usingBlock:(FRYFirstMatchBlock)block;
{
    NSParameterAssert(predicate);
    NSParameterAssert(block);

    FRYLookupResult *match = [self fry_enumerateDepthFirstViewMatching:predicate];
    block(match.view, match.frame);
}

- (FRYLookupResult *)fry_enumerateDepthFirstViewMatching:(NSPredicate *)predicate
{
    NSParameterAssert(predicate);
    for ( NSString *childKeyPath in self.class.fry_childKeyPaths ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            FRYLookupResult *result = [child fry_enumerateDepthFirstViewMatching:predicate];
            if ( result ) {
                return result;
            }
        }
    }

    if ( [predicate evaluateWithObject:self substitutionVariables:nil] ) {
        return [self fry_lookupResult];
    }
    
    return nil;
}

- (BOOL)fry_hasSubviewViewMatching:(NSPredicate *)predicate
{
    NSParameterAssert(predicate);
    NSMutableArray *array = [NSMutableArray array];
    [self fry_enumerateAllViewsMatching:predicate results:array];
    return array.count != 0;
}

- (void)fry_enumerateAllViewsMatching:(NSPredicate *)predicate usingBlock:(FRYFirstMatchBlock)block
{
    NSParameterAssert(predicate);
    NSParameterAssert(block);
    NSMutableArray *results = [NSMutableArray array];

    [self fry_enumerateAllViewsMatching:predicate results:results];

    for ( FRYLookupResult *result in results ) {
        block(result.view, result.frame);
    }
}

- (void)fry_enumerateAllViewsMatching:(NSPredicate *)predicate results:(NSMutableArray *)results
{
    NSParameterAssert(predicate);
    NSParameterAssert(results);

    if ( [predicate evaluateWithObject:self substitutionVariables:nil] ) {
        [results addObject:[self fry_lookupResult]];
    }

    for ( NSString *childKeyPath in self.class.fry_childKeyPaths ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            [child fry_enumerateAllViewsMatching:predicate results:results];
        }
    }
}

@end

@implementation UIApplication(FRYLookupSupport)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:NSStringFromSelector(@selector(windows))];
}

@end

@implementation UIAccessibilityElement(FRYLookupSupport)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:NSStringFromSelector(@selector(fry_accessibilityElements))];
}

- (FRYLookupResult *)fry_lookupResult
{
    return [[FRYLookupResult alloc] initWithView:[self fry_containingView] frame:[self accessibilityFrame]];
}

@end

@implementation UIView(FRYLookupSupport)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObjects:NSStringFromSelector(@selector(fry_accessibilityElements)), NSStringFromSelector(@selector(fry_reverseSubviews)), nil];
}

- (FRYLookupResult *)fry_lookupResult
{
    return [[FRYLookupResult alloc] initWithView:self frame:self.bounds];
}

@end


@implementation UIDatePicker(FRYLookupSupport)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet set];
}

@end
