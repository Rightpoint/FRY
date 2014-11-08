//
//  NSObject+FRYLookup.m
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "NSObject+FRYLookup.h"
#import "UIView+FRY.h"
#import "UIAccessibility+FRY.h"

@interface NSObject(FRYLookup)<FRYLookup>
@end

@implementation NSObject(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    [NSException raise:NSInvalidArgumentException format:@"%@ does not support being traversed", self.class];
    return nil;
}

- (UIView *)fry_representingView
{
    [NSException raise:NSInvalidArgumentException format:@"%@ does not support being a result", self.class];
    return nil;
}

- (CGRect)fry_frameInView
{
    [NSException raise:NSInvalidArgumentException format:@"%@ does not support being a result", self.class];
    return CGRectZero;
}

- (void)fry_farthestDescendentMatching:(NSPredicate *)predicate usingBlock:(FRYMatchBlock)block;
{
    NSParameterAssert(predicate);
    NSParameterAssert(block);
    
    id<FRYLookup> result = [self fry_farthestDescendentMatching:predicate];
    block([result fry_representingView], [result fry_frameInView]);
}

- (id<FRYLookup>)fry_farthestDescendentMatching:(NSPredicate *)predicate
{
    NSParameterAssert(predicate);
    for ( NSString *childKeyPath in [self.class fry_childKeyPaths] ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            id<FRYLookup> result = [child fry_farthestDescendentMatching:predicate];
            if ( result ) {
                return result;
            }
        }
    }
    
    if ( [predicate evaluateWithObject:self substitutionVariables:nil] ) {
        NSAssert([self conformsToProtocol:@protocol(FRYLookup)], @"%@ does not conform to %@", self, @protocol(FRYLookup));
        return (id<FRYLookup>)self;
    }
    
    return nil;
}

- (void)fry_enumerateAllChildrenMatching:(NSPredicate *)predicate usingBlock:(FRYMatchBlock)block
{
    NSParameterAssert(predicate);
    NSParameterAssert(block);
    NSMutableArray *results = [NSMutableArray array];
    
    [self fry_enumerateAllChildrenMatching:predicate results:results];
    
    for ( id<FRYLookup> result in results ) {
        block([result fry_representingView], [result fry_frameInView]);
    }
}

- (void)fry_enumerateAllChildrenMatching:(NSPredicate *)predicate results:(NSMutableArray *)results
{
    NSParameterAssert(predicate);
    NSParameterAssert(results);
    
    if ( [predicate evaluateWithObject:self substitutionVariables:nil] ) {
        [results addObject:self];
    }
    
    for ( NSString *childKeyPath in [self.class fry_childKeyPaths] ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            [child fry_enumerateAllChildrenMatching:predicate results:results];
        }
    }
}

@end


@implementation UIApplication(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:NSStringFromSelector(@selector(windows))];
}

- (UIView *)fry_representingView
{
    [NSException raise:NSInvalidArgumentException format:@"%@ does not support being a result", self.class];
    return nil;
}

- (CGRect)fry_frameInView
{
    [NSException raise:NSInvalidArgumentException format:@"%@ does not support being a result", self.class];
    return CGRectZero;
}

@end

@implementation UIAccessibilityElement(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:NSStringFromSelector(@selector(fry_accessibilityElements))];
}

- (UIView *)fry_representingView
{
    UIAccessibilityElement *element = self;
    while ( element && ![element isKindOfClass:[UIView class]] ) {
        // Sometimes accessibilityContainer will return a view that's too far up the view hierarchy
        // UIAccessibilityElement instances will sometimes respond to view, so try to use that and then fall back to accessibilityContainer
        id view = [element respondsToSelector:@selector(view)] ? [(id)element view] : nil;
        
        if (view) {
            element = view;
        } else {
            element = [element accessibilityContainer];
        }
    }
    
    return (UIView *)element;
}

- (CGRect)fry_frameInView
{
    UIView *view = [self fry_representingView];
    CGRect frame = [view convertRect:[self accessibilityFrame] fromView:[view window]];
    return frame;
}

@end


@implementation UIView(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObjects:NSStringFromSelector(@selector(fry_accessibilityElements)), NSStringFromSelector(@selector(fry_reverseSubviews)), nil];
}

- (UIView *)fry_representingView
{
    return self;
}

- (CGRect)fry_frameInView
{
    return self.bounds;
}

@end


@implementation UIDatePicker(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet set];
}

@end
