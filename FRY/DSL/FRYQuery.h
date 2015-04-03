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
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYSearchBlock)(FRYDirection FRYDirection, NSPredicate *content);
typedef BOOL(^FRYLookupBlock)(NSPredicate *content);
typedef BOOL(^FRYIntCheckBlock)(NSUInteger count);

typedef BOOL(^FRYBoolResultsBlock)(NSSet *);
typedef BOOL(^FRYBoolCallbackBlock)(NSString *message, FRYBoolResultsBlock check);

/**
 *  FRYQuery provides a consistent DSL to lookup and interact with UI components, as well
 *  as mechanisms to retry queries until they are satisfied, and report failures to test 
 *  frameworks.
 *
 *  The most common usage involve using the macro `FRY`
 */
@interface FRYQuery : NSObject

/**
 *  Perform a new lookup with the specified predicate. This will query all views
 *  that match the specified predicate. If this method is called multiple times,
 *  a new query object will be returned that will restart the query starting with
 *  the results of the previous query.
 */
@property (copy, nonatomic, readonly) FRYChainPredicateBlock lookup;

/**
 *  Convert the query to a shallow search. This will cause only the first matching
 *  result to be returned. This is performed implicitly by all of the interaction
 *  functions (touch, scroll, select, etc)
 */
@property (copy, nonatomic, readonly) FRYChainBlock shallow;

/**
 *  This will call `lookup` with the most common predicate settings: matching
 *  the specified accessibility label, that the element is on screen, and that the
 *  element is visible (All parent views have 'hidden != YES && alpha > 0.1').
 */
@property (copy, nonatomic, readonly) FRYChainStringBlock lookupByAccessibilityLabel;

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
 *  the specified predicate and scroll such that it is visible. The view must be installed
 *  in the view hierarchy to work.
 *
 *  This will modify the query to perform a shallow search.
 */
@property (copy, nonatomic, readonly) FRYLookupBlock scrollTo;

/**
 *  Find the first UIScrollView below the current lookup filter, and look in the specified direction
 *  for a subview that matches the specified predicate. This will scroll the scroll view and allow
 *  the view to load any cells that may be present.
 *
 *  This will modify the query to perform a shallow search.
 */
@property (copy, nonatomic, readonly) FRYSearchBlock searchFor;

/**
 *  Find the first UITextField or UITextView below the current lookup filter, and select all of the
 *  entered text.
 *  This will modify the query to perform a shallow search.
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
 *
 *  NOTE: If you are getting compile errors, cast the return excessively, ie: return (BOOL)(count == 1);
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

/**
 *  Specify the default timeout to use
 */
+ (void)setDefaultTimeout:(NSTimeInterval)timeout;

/**
 *  This is the constructor for new queries, used by the FRY macro.
 */
+ (FRYQuery *)queryFrom:(id<FRYLookup>)lookupRoot context:(FRYTestContext *)context;

@end


