//
//  FRYTarget.h
//  FRY
//
//  Created by Brian King on 10/4/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"

// Oh evil NSObject category, how I love you.
#import <UIKit/UIAccessibility.h>

typedef NS_ENUM(NSInteger, FRYTargetWindow) {
    FRYTargetWindowKey = 0,
    FRYTargetWindowAll,
};

/**
 * This object specifies a target to interact with.   This object
 * is designed to not know about UIKit objects to ensure that it can
 * be safely used off of the main thread.
 */
@interface FRYTarget : NSObject

+ (FRYTarget *)targetAccessibilityLabel:(NSString *)accessibilityLabel
                     accessibilityValue:(NSString *)accessibilityValue
                    accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits;

+ (FRYTarget *)targetWithViewsMatchingPredicate:(NSPredicate *)predicate;

@property (assign, nonatomic) FRYTargetWindow targetWindow;
@property (strong, nonatomic) id<FRYLookup> lookup;

@end
