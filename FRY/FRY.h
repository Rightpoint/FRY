//
//  FRY.h
//  FRY
//
//  Created by Brian King on 11/1/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FRYTouch.h"
#import "FRYTouchDispatch.h"
#import "FRYQuery.h"
#import "FRYIdleCheck.h"

#import "NSObject+FRYLookup.h"
#import "NSRunLoop+FRY.h"
#import "UIView+FRY.h"
#import "UIApplication+FRY.h"
#import "FRYTypist.h"
#import "UIAccessibility+FRY.h"
#import "UITextInput+FRY.h"
#import "UIPickerView+FRY.h"
#import "NSPredicate+FRY.h"
#import "UIScrollView+FRY.h"

/**
 *  Main entry point for fry. All commands start from here.
 *
 *  // Tap a label
 *  FRY.lookupByAccessibilityLabel(label).tap();
 *
 *  // Wait for the label to be absent
 *  FRY.lookupByAccessibilityLabel(label).absent();
 *
 *  // Find all views with non-nil accessibilityLabels
 *  views = FRY.lookup(FRY_PREDICATE_KEYPATH(UIView, accessibilityLabel, !=, nil)).views;
 *
 *  // Scroll down to row 9 in section 0, and tap that cell
 *  FRY.searchFor(FRYDirectionDown, FRY_atSectionAndRow(0, 9)).tap();
 *
 *  // Select the text in the first UITextField
 *  FRY.selectText();
 */
#define FRY ({[FRYQuery queryFrom:[UIApplication sharedApplication] context:FRY_TEST_CONTEXT];})

FOUNDATION_EXPORT double FRYVersionNumber;
FOUNDATION_EXPORT const unsigned char FRYVersionString[];
