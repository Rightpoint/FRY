//
//  IDLookupStrategy.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYAccessibilityLookup.h"

#import "FRYViewLookupStrategy.h"

@interface FRYAccessibilityLookup()

@property (nonatomic, copy) NSString *accessibilityLabel;
@property (nonatomic, copy) NSString *accessibilityValue;
@property (nonatomic, assign) UIAccessibilityTraits accessibilityTraits;

@end

@implementation FRYAccessibilityLookup

- (id)initWithAccessibilityLabel:(NSString *)accessibilityLabel accessibilityValue:(NSString *)accessibilityValue accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
{
    self = [super init];
    if ( self ) {
        _accessibilityLabel = accessibilityLabel;
        _accessibilityValue = accessibilityValue;
        _accessibilityTraits = accessibilityTraits;
    }
    return self;
}

- (NSArray *)lookForMatchingObjectsStartingFrom:(NSObject *)object
{
    FRYAccessibilityLookupStrategy *strategy = object.class.lookupStrategy;
    return @[[strategy queryObject:object
             forAccessibilityLabel:_accessibilityLabel
                accessibilityValue:_accessibilityValue
               accessibilityTraits:_accessibilityTraits]];
}

@end
