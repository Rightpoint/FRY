//
//  IDLookupStrategy.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYQuery.h"
#import <UIKit/UIKit.h>

@interface FRYAccessibilityQuery : NSObject <FRYQuery>

- (id)initWithAccessibilityLabel:(NSString *)label
              accessibilityValue:(NSString *)accessibilityValue
             accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

@end
