//
//  FRYQueryBuilder.h
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FRYLookup.h"
#import "FRYTestContext.h"
#import "FRYDefines.h"

@class FRYQuery;
@class FRYTestContext;

typedef FRYQuery *(^FRYChainBlock)(id predicateOrArrayOfPredicates);
typedef FRYQuery *(^FRYChainStringBlock)(NSString *string);
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYSearchBlock)(NSInteger FRYDirection, NSPredicate *content);
typedef BOOL(^FRYLookupBlock)(NSPredicate *content);
typedef BOOL(^FRYIntCheckBlock)(NSUInteger count);

typedef BOOL(^FRYBoolResultsBlock)(NSSet *);
typedef BOOL(^FRYBoolCallbackBlock)(NSString *message, FRYBoolResultsBlock check);

/**
 *  FRYQuery provides a consistent DSL to lookup and interact with UI components, as well
 *  as mechanisms to retry queries until they are satisfied, and report failures to test 
 *  frameworks.
 * 
 *  A FRYQuery object has a focus, which by default points to `[UIApplication sharedApplication]`,
 *  which will query all subviews on all windows. The lookup methods provide predicates which 
 *  further focus the query onto specific elements, and multiple lookup methods can be chained
 *  together to further focus the lookup. Once the query is specific enough, an action can be 
 *  performed to simulate a touch, scroll a scrollview, or select entered text.
 *
 *  FRYQuery can perform two kinds of lookup. A query of everything matching a predicate,
 *  or the most shallow element that matches the predicate. For actions involving interaction,
 *  the shallow query `lookupFirst` should be used. This allows the user to ignore many private
 *  implementation subviews. For queries that check the state of the view hierarchy, the full
 *  query may be desired.
 *
 *  There is one lookup helper, `lookupFirstByAccessibilityLabel`, which will perform a shallow
 *  search for the first element that matches the accessibilityLabel, is on the screen, and is not
 *  hidden. This is provided as a convienence, and is the most common lookup to use in the majority of
 *  cases.
 */
@interface FRYQuery : NSObject

/**
 *  Specify the default timeout to use
 */
+ (void)setDefaultTimeout:(NSTimeInterval)timeout;

/**
 *  This is the constructor for new queries, used by the FRY macro.
 */
+ (FRYQuery *)queryFrom:(id<FRYLookup>)lookupRoot context:(FRYTestContext *)context;

/**
 *  Perform a new lookup with the specified predicate. This will query all views
 *  that match the specified predicate. If this method is called multiple times,
 *  a new query object will be returned that will restart the query starting with
 *  the results of the previous query.
 */
@property (copy, nonatomic, readonly) FRYChainBlock lookup;

/**
 *  Same as the lookup function, except only the first, most shallow result will be
 *  used.
 */
@property (copy, nonatomic, readonly) FRYChainBlock lookupFirst;

/**
 *  This will call `lookupFirst` with the most common predicate settings: matching
 *  the specified accessibility label, that the element is on screen, and that the
 *  element is visible (All parent views have 'hidden != YES && alpha > 0.1').
 */
@property (copy, nonatomic, readonly) FRYChainStringBlock lookupFirstByAccessibilityLabel;

/**
 *  Find the first view that matches the current lookup filter and perform a tap on it.
 *  This will modify the query to perform a shallow search.
 */
@property (copy, nonatomic, readonly) FRYCheckBlock tap;

/**
 *  Find the first view that matches the current lookup filter and perform the touches on it.
 *  This will modify the query to perform a shallow search.
 */
@property (copy, nonatomic, readonly) FRYTouchBlock touch;

/**
 *  Find the first UIScrollView below the current lookup filter. Lookup the subview that matches
 *  the specified predicate and scroll such that it is visible.
 */
@property (copy, nonatomic, readonly) FRYLookupBlock scrollTo;

/**
 *  Find the first UIScrollView below the current lookup filter, and look in the specified direction
 *  for a subview that matches the specified predicate.
 */
@property (copy, nonatomic, readonly) FRYSearchBlock searchFor;

/**
 *  Find the first UITextField or UITextView below the current lookup filter, and select all of the
 *  entered text.
 */
@property (copy, nonatomic, readonly) FRYCheckBlock selectText;

/**
 *  Block and retry the query until the current lookup filter returns a view.
 */
@property (copy, nonatomic, readonly) FRYCheckBlock present;

/**
 *  Block and retry the query until the current lookup filter returns no views.
 */
@property (copy, nonatomic, readonly) FRYCheckBlock absent;

/**
 *  Block and retry the query until the current lookup filter returns the specified number of views.
 */
@property (copy, nonatomic, readonly) FRYIntCheckBlock count;

/**
 *  Block and retry the query until the specified check block returns YES.
 */
@property (copy, nonatomic, readonly) FRYBoolCallbackBlock check;

/**
 *  Return all current views specified by the query. This will not retry
 */
@property (copy, nonatomic, readonly) NSArray *views;

/**
 *  Return the first view specified by the query. This will not retry or modify the lookup type.
 *  If the query is returning all matching elements, the first of those elements will be returned.
 */
@property (strong, nonatomic, readonly) UIView *view;

@end


// A few predicate helpers
#ifdef FRY_SHORTHAND
#define ofKind(c) [NSPredicate fry_matchClass:c]
#define accessibilityLabel(v) [NSPredicate fry_matchAccessibilityLabel:v]
#define accessibilityValue(v) [NSPredicate fry_matchAccessibilityValue:v]
#define accessibilityTrait(v) [NSPredicate fry_matchAccessibilityTrait:v]
#define atIndexPath(v) [NSPredicate fry_matchContainerIndexPath:indexPath]
#else
#define FRY_ofKind(c) [NSPredicate fry_matchClass:c]
#define FRY_accessibilityLabel(v) [NSPredicate fry_matchAccessibilityLabel:v]
#define FRY_accessibilityValue(v) [NSPredicate fry_matchAccessibilityValue:v]
#define FRY_accessibilityTrait(v) [NSPredicate fry_matchAccessibilityTrait:v]
#define FRY_atIndexPath(v) [NSPredicate fry_matchContainerIndexPath:v]
#define FRY_atSectionAndRow(s, r) [NSPredicate fry_matchContainerIndexPath:[NSIndexPath indexPathForRow:r inSection:s]]
#endif
