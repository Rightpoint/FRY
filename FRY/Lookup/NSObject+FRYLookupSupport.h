//
//  NSObject+FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYLookupSupport.h"


OBJC_EXTERN NSString* const kFRYLookupAccessibilityLabel;
OBJC_EXTERN NSString* const kFRYLookupAccessibilityValue;
OBJC_EXTERN NSString* const kFRYLookupAccessibilityTrait;

@interface NSObject(FRYLookupSupport) <FRYLookupSupport>

@end

@interface UIAccessibilityElement(FRYLookupSupport) <FRYLookupSupport>

@end

