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
#import "NSPredicate+FRY.h"
#import "UIApplication+FRY.h"

typedef void(^FRYMatchBlock)(UIView *view, CGRect frameInView);

@interface NSObject(FRYLookup)<FRYLookup>
@end

static NSArray *__fry_enableLookupDebugForObjects = nil;

@implementation NSObject(FRYLookupDebug)

+ (void)fry_enableLookupDebugForObjects:(NSArray *)objects
{
    __fry_enableLookupDebugForObjects = objects;
}

@end

@implementation NSObject(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:FRY_KEYPATH(NSObject, fry_accessibilityElements)];
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

- (BOOL)fry_isOnScreen
{
    UIView *view = [self fry_representingView];
    UIWindow *window = [view window];
    BOOL onScreen = NO;
    if ( window ) {
        CGRect frameInWindow = [window convertRect:[self fry_frameInView] fromView:view.superview];
        onScreen = window && CGRectIntersectsRect(window.bounds, frameInWindow);
    }
    return onScreen;
}

- (BOOL)fry_isAnimating
{
    return NO;
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

- (id<FRYLookup>)fry_firstDescendentMatching:(NSPredicate *)predicate;
{
    NSParameterAssert(predicate);

    if ( [predicate evaluateWithObject:self substitutionVariables:nil] ) {
        NSAssert([self conformsToProtocol:@protocol(FRYLookup)], @"%@ does not conform to %@", self, @protocol(FRYLookup));
        return (id<FRYLookup>)self;
    }

    for ( NSString *childKeyPath in [self.class fry_childKeyPaths] ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            id<FRYLookup> result = [child fry_firstDescendentMatching:predicate];
            if ( result ) {
                return result;
            }
        }
    }
    return nil;
}

- (void)fry_enumerateAllChildrenMatching:(NSPredicate *)predicate results:(NSMutableSet *)results debug:(BOOL)debug
{
    NSParameterAssert(predicate);
    NSParameterAssert(results);
    
    BOOL match = [predicate evaluateWithObject:self substitutionVariables:nil];
    if ( debug ) {
        NSLog(@"%@%@", [predicate fry_descriptionOfEvaluationWithObject:self], match ? @" == MATCH" : @"");
    }
    if ( match ) {
        [self fry_addNonDuplicateObject:self toResults:results];
    }
    
    for ( NSString *childKeyPath in [self.class fry_childKeyPaths] ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            BOOL childDebug = debug == NO ? [__fry_enableLookupDebugForObjects containsObject:child] : YES;
            [child fry_enumerateAllChildrenMatching:predicate
                                            results:results
                                              debug:childDebug];
        }
    }
}

/**
 *  We have to perform some special duplicate checking durring all enumeration. While traversing the entire tree,
 *  views and accessibilityElements can match the same logical result in different objects. This method 
 *  will compaire the results of fry_representingView and fry_frameInView to determine duplicates.
 */
- (void)fry_addNonDuplicateObject:(NSObject<FRYLookup> *)object toResults:(NSMutableSet *)results
{
    BOOL duplicate = NO;
    for ( NSObject<FRYLookup> *result in results ) {
        if ( [[object fry_representingView] isEqual:[result fry_representingView]] &&
            CGRectEqualToRect([object fry_frameInView], [result fry_frameInView]) ) {
            duplicate = YES;
            break;
        }
    }
    if ( duplicate == NO ) {
        [results addObject:object];
    }
}

- (NSSet *)fry_allChildrenMatching:(NSPredicate *)predicate
{
    NSMutableSet *results = [NSMutableSet set];
    
    [self fry_enumerateAllChildrenMatching:predicate results:results debug:NO];
    
    return [results copy];
}

@end


@implementation UIApplication(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:FRY_KEYPATH(UIApplication, fry_allWindows)];
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

static BOOL FRYViewLookupAccessibilityChildren = YES;

@implementation UIView(FRYLookup)

+ (void)setLookupAccessibilityChildren:(BOOL)lookupAccessibilityChildren
{
    FRYViewLookupAccessibilityChildren = lookupAccessibilityChildren;
}

+ (NSSet *)fry_childKeyPaths
{
    NSSet *children = [NSSet setWithObject:FRY_KEYPATH(UIView, fry_reverseSubviews)];
    if ( FRYViewLookupAccessibilityChildren ) {
        children = [children setByAddingObject:FRY_KEYPATH(UIView, fry_accessibilityElements)];
    }
    return children;
}

- (UIView *)fry_representingView
{
    return self;
}

- (CGRect)fry_frameInView
{
    return self.frame;
}

@end


@implementation UIDatePicker(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet set];
}

@end
