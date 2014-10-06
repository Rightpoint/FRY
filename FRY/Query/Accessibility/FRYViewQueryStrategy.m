//
//  IDViewLookupStrategy.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYViewQueryStrategy.h"

@implementation FRYViewQueryStrategy

- (NSObject *)checkObject:(UIView *)view
    forAccessibilityLabel:(NSString *)accessibilityLabel
       accessibilityValue:(NSString *)accessibilityValue
      accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    NSObject *result = nil;
    
    if ( view.hidden == NO ) {
        result = [super queryObject:view
              forAccessibilityLabel:accessibilityLabel
                 accessibilityValue:accessibilityValue
                accessibilityTraits:accessibilityTraits];
    }
    
    return result;
}


- (NSObject *)checkChildrenOfObject:(UIView *)view
              forAccessibilityLabel:(NSString *)accessibilityLabel
                 accessibilityValue:(NSString *)accessibilityValue
                accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;
{
    NSObject *result = nil;
    
    // Lookup via subviews before accessibility
    for (UIView *subview in [view.subviews reverseObjectEnumerator]) {
        FRYAccessibilityQueryStrategy *subviewStrategy = [subview.class queryStrategy];
        
        result = [subviewStrategy queryObject:subview
                        forAccessibilityLabel:accessibilityLabel
                           accessibilityValue:accessibilityValue
                          accessibilityTraits:accessibilityTraits];
        
        if ( result ) {
            continue;
        }
    }
    
    if ( result == nil ) {
        result = [super checkChildrenOfObject:view
                        forAccessibilityLabel:accessibilityLabel
                           accessibilityValue:accessibilityValue
                          accessibilityTraits:accessibilityTraits];
    }
    return result;
}


@end


@interface UIView(FRYQueryStrategy)
@end

@implementation UIView(FRYQueryStrategy)

+ (FRYAccessibilityQueryStrategy *)queryStrategy
{
    static FRYAccessibilityQueryStrategy *strategy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        strategy = [[FRYViewQueryStrategy alloc] init];
    });
    return strategy;
}

@end
