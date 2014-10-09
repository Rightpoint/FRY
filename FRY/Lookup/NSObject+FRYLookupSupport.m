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

NSString* const kFRYLookupAccessibilityValue = @"accessibilityValue";
NSString* const kFRYLookupAccessibilityLabel = @"accessibilityLabel";
NSString* const kFRYLookupAccessibilityTrait = @"accessibilityTrait";

@implementation NSObject(FRYLookupSupport)

+ (id<FRYLookup>)fry_lookup
{
    // A lookup can not work, since the NSObject extension does not allow us to obtain
    // the containing UIView.  Since NSObject is the only shared heritage between UIView and UIAccessibilityElement
    // support NSObject for the compilers sake, even though we can't do much here.
    NSAssert(NO, @"Can not create results from NSObject!");
    return nil;
}

+ (NSPredicate *)fry_accessibilityPredicate
{
    return [NSPredicate predicateWithBlock:^BOOL(NSObject *object, NSDictionary *bindings) {
        NSString *accessibilityLabel = bindings[kFRYLookupAccessibilityLabel];
        NSString *accessibilityValue = bindings[kFRYLookupAccessibilityValue];
        UIAccessibilityTraits accessibilityTraits = [bindings[kFRYLookupAccessibilityTrait] integerValue];
        return ((accessibilityLabel == nil || [[object fry_accessibilityLabel] isEqualToString:accessibilityLabel]) &&
                (accessibilityValue == nil || [[object fry_accessibilityValue] isEqualToString:accessibilityValue]) &&
                ([object accessibilityTraits] & accessibilityTraits) == accessibilityTraits );
    }];
}

@end


@implementation UIAccessibilityElement(FRYLookupSupport)

+ (id<FRYLookup>)fry_lookup
{
    FRYLookup *fryQuery = [[FRYLookup alloc] init];
    fryQuery.childKeyPaths = @[NSStringFromSelector(@selector(fry_accessibilityElements))];
    fryQuery.matchPredicate = [self fry_accessibilityPredicate];
    fryQuery.matchTransform = ^FRYLookupResult *(UIAccessibilityElement *obj) {
        FRYLookupResult *result = [[FRYLookupResult alloc] init];
        result.view = [obj fry_containingView];
        result.frame = [obj accessibilityFrame];
        return result;
    };
    return fryQuery;
}

@end

@implementation UIView(FRYLookupSupport)

+ (id<FRYLookup>)fry_lookup
{
    FRYLookup *fryQuery = [[FRYLookup alloc] init];
    fryQuery.childKeyPaths = @[NSStringFromSelector(@selector(subviews)), NSStringFromSelector(@selector(fry_accessibilityElements))];
    fryQuery.matchPredicate = [self fry_accessibilityPredicate];
    fryQuery.descendPredicate = [NSPredicate predicateWithBlock:^BOOL(NSObject *object, NSDictionary *bindings) {
        if ( [object isKindOfClass:[UIView class]] ) {
            UIView *view = (UIView *)object;
            return view.hidden == NO;
        }
        else {
            return YES;
        }
    }];
    fryQuery.matchTransform = ^FRYLookupResult *(UIView *view) {
        FRYLookupResult *result = [[FRYLookupResult alloc] init];
        result.view = view;
        result.frame = view.bounds;
        return result;
    };
    return fryQuery;
}

@end


@implementation UIDatePicker(FRYLookupSupport)

+ (id<FRYLookup>)fry_lookup
{
    FRYLookup *fryQuery = (FRYLookup *)[super fry_lookup];
    // UIDatePicker has tons of children, none of which we care about.
    fryQuery.descendPredicate = [NSPredicate predicateWithValue:NO];
    return fryQuery;
}


@end
