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

@class FRYTestContext;

typedef FRYQuery *(^FRYChainPredicateBlock)(id predicateOrArrayOfPredicates);
typedef FRYQuery *(^FRYChainStringBlock)(NSString *string);
typedef FRYQuery *(^FRYChainBlock)();
typedef FRYQuery *(^FRYChainSelectBlock)(NSString *value, NSUInteger component);
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYSearchBlock)(FRYDirection FRYDirection, NSPredicate *contentPredicate);
typedef BOOL(^FRYLookupBlock)(NSPredicate *contentPredicate);
typedef BOOL(^FRYIntCheckBlock)(NSUInteger count);

typedef BOOL(^FRYBoolResultsBlock)(NSSet *results);
typedef BOOL(^FRYBoolCallbackBlock)(NSString *message, FRYBoolResultsBlock check);

/**
 *  FRYQuery provides a consistent DSL to lookup and interact with UI components, as well
 *  as mechanisms to retry queries until they are satisfied, and report failures to test 
 *  frameworks.
 */
@interface FRYQuery : NSObject

/**
 *  Create a new query from the lookupRoot.
 *
 *  The FRY macro will create a new instance of FRYQuery with [UIApplication sharedApplication] as
 *  the lookupRoot, and FRY_TEST_CONTEXT as the context.
 *
 *  Direct usage of this query is probably not needed to do what you want.
 */
+ (FRYQuery *)queryFrom:(id<FRYLookup>)lookupRoot context:(FRYTestContext *)context;

/**
 *  Filter the query with the supplied predicate. This performs a non-exhaustive search from the 
 *  lookupOrigin. It is a non-exhaustive in that once a node is encountered that matches the predicate, 
 *  the children of that node will not also be queried.
 *
 *  When this method is called multiple times, subsequent queries will create a new FRYQuery with the 
 *  previous FRYQuery as the lookupRoot. This allows for powerful query chaining.
 *
 *  @param predicateOrArrayOfPredicates The predicate to filter with. If an array is specified, it is converted to an and predicate.
 */
@property (copy, nonatomic, readonly) FRYChainPredicateBlock lookup;

/**
 *  This will call `lookup` with the most common predicate settings - matching
 *  the specified accessibility label(FRY_accessibilityLabel) and that the element is
 *  on the screen and visible(FRY_isOnScreen(YES)), and not animating (FRY_isAnimating(NO)).
 *
 *  @param accessibilityLabel  The accessibility label to look for.
 */
@property (copy, nonatomic, readonly) FRYChainStringBlock lookupByAccessibilityLabel;

/**
 *  Tap the first result of the query.
 */
@property (copy, nonatomic, readonly) FRYCheckBlock tap;

/**
 *  Perform the specified touches on the first result of the query.
 *
 *  @param  touchOrArrayOfTouches An array (for multi-touch) or singular touch object to dispatch
 */
@property (copy, nonatomic, readonly) FRYTouchBlock touch;

/**
 *  Find the first UIScrollView in the lookupRoot. Another query will find the subview that matches
 *  the specified predicate and scroll such that it is visible. The view must be
 *  in the application hierarchy to work, or must be returned by the accessiblity hierarchy.
 *
 *  @param contentPredicate The predicate to look for
 */
@property (copy, nonatomic, readonly) FRYLookupBlock scrollTo;

/**
 *  Find the first UIScrollView below the current lookup filter, and look in the specified direction
 *  for a subview that matches the specified predicate. This will scroll the scroll view and allow
 *  the view to load any cells that may be present.
 *
 *  @param  direction  The direction to look in
 *  @param  contentPredicate  The predicate to look for
 */
@property (copy, nonatomic, readonly) FRYSearchBlock searchFor;

/**
 *  Find the first UITextField or UITextView below the current lookup filter, and select all of the
 *  entered text.
 */
@property (copy, nonatomic, readonly) FRYCheckBlock selectText;

/**
 *  Find the first UIPickerView and select the label on the component
 * 
 *  @param  label  The label to select
 *  @param  component  The component of the picker view to select
 */
@property (copy, nonatomic, readonly) FRYChainSelectBlock selectPicker;

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
 *
 *  NOTE: If you are getting compile errors, cast the return excessively, ie: return (BOOL)(count == 1);
 */
@property (copy, nonatomic, readonly) FRYBoolCallbackBlock check;

/**
 *  Return all current views specified by the query, sorted by origin.
 */
@property (copy, nonatomic, readonly) NSArray *views;

/**
 *  Return the first view specified by the query.
 */
@property (strong, nonatomic, readonly) UIView *view;

/**
 *  Specify the default timeout to use
 */
+ (void)setDefaultTimeout:(NSTimeInterval)timeout;

@end


