//
//  IDLookupStrategy.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYLookup.h"
#import <UIKit/UIKit.h>

@interface FRYAccessibilityLookup : NSObject <FRYLookup>

- (id)initWithAccessibilityLabel:(NSString *)label
              accessibilityValue:(NSString *)accessibilityValue
             accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

@end
