//
//  IDAccessibilityLookupStrategy.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYAccessibilityLookupStrategy.h"

@implementation FRYAccessibilityLookupStrategy

- (NSObject *)queryObject:(NSObject *)object
    forAccessibilityLabel:(NSString *)accessibilityLabel
       accessibilityValue:(NSString *)accessibilityValue
      accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    NSObject *element = [self checkObject:object
                                  forAccessibilityLabel:accessibilityLabel
                                     accessibilityValue:accessibilityValue
                                    accessibilityTraits:accessibilityTraits];
    
    if ( element == nil ) {
        element = [self checkChildrenOfObject:object
                        forAccessibilityLabel:accessibilityLabel
                           accessibilityValue:accessibilityValue
                          accessibilityTraits:accessibilityTraits];
    }
    return element;
}

- (NSObject *)checkObject:(NSObject *)object
    forAccessibilityLabel:(NSString *)accessibilityLabel
       accessibilityValue:(NSString *)accessibilityValue
      accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{

    if ( (accessibilityLabel == nil || [[object accessibilityLabel] isEqualToString:accessibilityLabel]) &&
         (accessibilityValue == nil || [[object accessibilityValue] isEqualToString:accessibilityValue]) &&
         ([object accessibilityTraits] & accessibilityTraits) == accessibilityTraits ) {
        return object;
    }
    return nil;
}
- (void)foo:(inout NSError **)error
{
    
}
- (NSObject *)checkChildrenOfObject:(NSObject *)object
              forAccessibilityLabel:(NSString *)accessibilityLabel
                 accessibilityValue:(NSString *)accessibilityValue
                accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    NSObject *result = nil;
    NSUInteger count = object.accessibilityElementCount == NSNotFound ? 0 : object.accessibilityElementCount;
    for (NSInteger accessibilityElementIndex = 0; accessibilityElementIndex < count; accessibilityElementIndex++) {
        NSObject *subelement = [object accessibilityElementAtIndex:accessibilityElementIndex];
        // Does this happen?
        if (subelement == nil) { continue; }
        
        FRYAccessibilityLookupStrategy *strategy = [subelement.class lookupStrategy];
        result = [strategy queryObject:subelement
                 forAccessibilityLabel:accessibilityLabel
                    accessibilityValue:accessibilityValue
                   accessibilityTraits:accessibilityTraits];
        if ( result ) {
            break;
        }
    }
    
    return result;
}

@end

@implementation NSObject(FRYLookStrategy)

+ (FRYAccessibilityLookupStrategy *)lookupStrategy
{
    static FRYAccessibilityLookupStrategy *strategy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        strategy = [[FRYAccessibilityLookupStrategy alloc] init];
    });
    return strategy;
}

@end

