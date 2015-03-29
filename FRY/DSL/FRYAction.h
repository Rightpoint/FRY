//
//  FRYActionBuilder.h
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FRYLookup.h"
#import "FRYActionContext.h"

@class FRYAction;
@class FRYActionContext;

typedef FRYAction *(^FRYChainBlock)(id predicateOrArrayOfPredicates);
typedef FRYAction *(^FRYChainStringBlock)(NSString *string);
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYDirectionBlock)(NSInteger FRYDirection, NSPredicate *content);
typedef BOOL(^FRYBoolCheckBlock)();
typedef BOOL(^FRYIntCheckBlock)(NSUInteger count);

typedef BOOL(^FRYBoolResultsBlock)(NSSet *);
typedef BOOL(^FRYBoolCallbackBlock)(NSString *message, FRYBoolResultsBlock check);


#define FRY2 ({[FRYAction actionFrom:[UIApplication sharedApplication] context:FRY_ACTION_CONTEXT];})

@interface FRYAction : NSObject

+ (void)setDefaultTimeout:(NSTimeInterval)timeout;
+ (FRYAction *)actionFrom:(id<FRYLookup>)lookupRoot context:(FRYActionContext *)context;

@property (copy, nonatomic, readonly) FRYChainBlock lookup;
@property (copy, nonatomic, readonly) FRYChainBlock lookupFirst;
@property (copy, nonatomic, readonly) FRYChainStringBlock lookupFirstByAccessibilityLabel;

@property (copy, nonatomic, readonly) FRYBoolCheckBlock tap;
@property (copy, nonatomic, readonly) FRYTouchBlock touch;
@property (copy, nonatomic, readonly) FRYDirectionBlock scrollTo;
@property (copy, nonatomic, readonly) FRYBoolCheckBlock selectText;

@property (copy, nonatomic, readonly) FRYBoolCallbackBlock check;
@property (copy, nonatomic, readonly) FRYBoolCheckBlock present;
@property (copy, nonatomic, readonly) FRYBoolCheckBlock absent;
@property (copy, nonatomic, readonly) FRYIntCheckBlock count;

@property (copy, nonatomic, readonly) NSArray *views;
@property (strong, nonatomic, readonly) UIView *view;

@end


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
