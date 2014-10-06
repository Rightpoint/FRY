//
//  IDLookupStrategy.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYAccessibilityQuery.h"

#import "FRYViewQueryStrategy.h"

@interface FRYAccessibilityQuery()

@property (nonatomic, copy) NSString *accessibilityLabel;
@property (nonatomic, copy) NSString *accessibilityValue;
@property (nonatomic, assign) UIAccessibilityTraits accessibilityTraits;

@end

@implementation FRYAccessibilityQuery

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
    FRYAccessibilityQueryStrategy *strategy = object.class.queryStrategy;
    return @[[strategy queryObject:object
             forAccessibilityLabel:_accessibilityLabel
                accessibilityValue:_accessibilityValue
               accessibilityTraits:_accessibilityTraits]];
}

@end
