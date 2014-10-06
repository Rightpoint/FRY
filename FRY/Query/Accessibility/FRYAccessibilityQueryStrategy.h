//
//  IDAccessibilityLookupStrategy.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIAccessibility.h>

@interface FRYAccessibilityQueryStrategy : NSObject

- (NSObject *)queryObject:(NSObject *)object
    forAccessibilityLabel:(NSString *)accessibilityLabel
       accessibilityValue:(NSString *)accessibilityValue
      accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;




- (NSObject *)checkObject:(NSObject *)object
    forAccessibilityLabel:(NSString *)accessibilityLabel
       accessibilityValue:(NSString *)accessibilityValue
      accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

- (NSObject *)checkChildrenOfObject:(NSObject *)object
              forAccessibilityLabel:(NSString *)accessibilityLabel
                 accessibilityValue:(NSString *)accessibilityValue
                accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

@end

@interface NSObject(FRYQueryStrategy)

+ (FRYAccessibilityQueryStrategy *)queryStrategy;

@end
