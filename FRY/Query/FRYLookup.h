//
//  FRYTarget.h
//  FRY
//
//  Created by Brian King on 10/4/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
// Oh evil NSObject category, how I love you.
#import <UIKit/UIAccessibility.h>
#import "FRYQuery.h"

typedef void(^FRYLookupComplete)(void);

typedef NS_ENUM(NSInteger, FRYTargetWindow) {
    FRYTargetWindowKey = 0,
    FRYTargetWindowAll,
};

/**
 * This object specifies a target to interact with.   This object
 * is designed to not know about UIKit objects to ensure that it can
 * be safely used off of the main thread.
 */
@interface FRYLookup : NSObject

+ (FRYLookup *)lookupAccessibilityLabel:(NSString *)accessibilityLabel
                     accessibilityValue:(NSString *)accessibilityValue
                    accessibilityTraits:(UIAccessibilityTraits)accessibilityTraits
                              whenFound:(FRYSingularQueryResult)found;

+ (FRYLookup *)lookupViewsMatchingPredicate:(NSPredicate *)predicate whenFound:(FRYQueryResult)found;

@property (assign, nonatomic) FRYTargetWindow targetWindow;
@property (strong, nonatomic, readonly) id<FRYQuery> query;
@property (copy, nonatomic) FRYQueryResult whenFound;

/**
 * Return a block enclosing the results of a successful lookup, or nil if the lookup failed.
 */
- (FRYLookupComplete)foundBlockIfLookupIsFound;

@end
