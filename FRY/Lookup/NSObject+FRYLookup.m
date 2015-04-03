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

static NSArray *__fry_enableLookupDebugForObjects = nil;

@implementation NSObject(FRYLookup)

+ (NSSortDescriptor *)fry_sortDescriptorByOrigin;
{
    return [NSSortDescriptor sortDescriptorWithKey:FRY_KEYPATH(NSObject, fry_frameInWindow) ascending:YES comparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        CGRect frame1 = [obj1 CGRectValue];
        CGRect frame2 = [obj2 CGRectValue];
        NSComparisonResult result = [@(frame1.origin.y) compare:@(frame2.origin.y)];
        if (result == NSOrderedSame) {
            return [@(frame1.origin.x) compare:@(frame2.origin.x)];
        }
        return result;
    }];
}

+ (void)fry_enableLookupDebugForObjects:(NSArray *)objects
{
    __fry_enableLookupDebugForObjects = objects;
}

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet setWithObject:FRY_KEYPATH(NSObject, fry_accessibilityElements)];
}

- (UIView *)fry_representingView
{
    [NSException raise:NSInvalidArgumentException format:@"%@ does not support being a result", self.class];
    return nil;
}

- (CGRect)fry_frameInWindow
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
        onScreen = window && CGRectIntersectsRect(window.bounds, [self fry_frameInWindow]);
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

- (void)fry_nonExhaustiveShallowSearchForChildrenMatching:(NSPredicate *)predicate results:(NSMutableSet *)results debug:(BOOL)debug
{
    NSParameterAssert(predicate);
    NSParameterAssert(results);
    
    BOOL match = [predicate evaluateWithObject:self substitutionVariables:nil];
    if ( debug ) {
        NSLog(@"%@%@", [predicate fry_descriptionOfEvaluationWithObject:self], match ? @" == MATCH" : @"");
    }
    if ( match ) {
        [self fry_addNonDuplicateObject:self toResults:results];
        return;
    }
    
    for ( NSString *childKeyPath in [self.class fry_childKeyPaths] ) {
        NSArray *children = [self valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            BOOL childDebug = debug == NO ? [__fry_enableLookupDebugForObjects containsObject:child] : YES;
            [child fry_nonExhaustiveShallowSearchForChildrenMatching:predicate
                                                             results:results
                                                               debug:childDebug];
        }
    }
}

/**
 *  We have to perform some special duplicate checking durring all enumeration. While traversing the entire tree,
 *  views and accessibilityElements can match the same logical result in different objects. This method 
 *  will compaire the results of fry_representingView and fry_frameInWindow to determine duplicates.
 */
- (void)fry_addNonDuplicateObject:(NSObject<FRYLookup> *)object toResults:(NSMutableSet *)results
{
    BOOL duplicate = NO;
    for ( NSObject<FRYLookup> *result in results ) {
        if ( [[object fry_representingView] isEqual:[result fry_representingView]] &&
            CGRectEqualToRect([object fry_frameInWindow], [result fry_frameInWindow]) ) {
            duplicate = YES;
            break;
        }
    }
    if ( duplicate == NO ) {
        [results addObject:object];
    }
}

- (NSSet *)fry_nonExhaustiveShallowSearchForChildrenMatching:(NSPredicate *)predicate
{
    NSMutableSet *results = [NSMutableSet set];
    
    [self fry_nonExhaustiveShallowSearchForChildrenMatching:predicate results:results debug:NO];
    
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

- (CGRect)fry_frameInWindow
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

- (CGRect)fry_frameInWindow
{
    return [self accessibilityFrame];
}

@end

@implementation UIView(FRYLookup)

+ (NSMutableDictionary *)fry_disabledAccessibilityLookupByClass
{
    __block NSMutableDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = [NSMutableDictionary dictionary];
    });
    return dictionary;
}

+ (void)fry_setLookupAccessibilityChildren:(BOOL)lookupAccessibilityChildren
{
    self.fry_disabledAccessibilityLookupByClass[NSStringFromClass(self)] = @(lookupAccessibilityChildren);
}

+ (BOOL)fry_lookupAccessibilityChildren
{
    NSNumber *lookupNumber = self.fry_disabledAccessibilityLookupByClass[NSStringFromClass(self)];
    return lookupNumber ? [lookupNumber boolValue] : YES;
}

+ (NSSet *)fry_childKeyPaths
{
    NSSet *children = [NSSet setWithObject:FRY_KEYPATH(UIView, fry_reverseSubviews)];
    if ( [self fry_lookupAccessibilityChildren] ) {
        children = [children setByAddingObject:FRY_KEYPATH(UIView, fry_accessibilityElements)];
    }
    return children;
}

- (UIView *)fry_representingView
{
    return self;
}

- (CGRect)fry_frameInWindow
{
    CGRect frameInWindow = [self convertRect:self.bounds toView:self.window];
    return frameInWindow;
}

- (BOOL)fry_isAnimating
{
    NSTimeInterval uptime = [[NSProcessInfo processInfo] systemUptime];
    BOOL isAnimating = NO;

    for (NSString *animationKey in self.layer.animationKeys ) {
        CAAnimation *animation = [self.layer animationForKey:animationKey];
        NSTimeInterval animationEnd = animation.beginTime + animation.duration + animation.timeOffset;

        if ( [animation.fillMode isEqualToString:kCAFillModeRemoved] ) {
            isAnimating = YES;
        }
        else if ( animationEnd > uptime ) {
            isAnimating = YES;
        }
    }
    return isAnimating;
}

- (BOOL)fry_isOnScreen
{
    return [super fry_isOnScreen] && [self fry_isVisible];
}

@end


@implementation UIDatePicker(FRYLookup)

+ (NSSet *)fry_childKeyPaths
{
    return [NSSet set];
}

@end
