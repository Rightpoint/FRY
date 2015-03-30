//
//  FRYDefines.h
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^FRYCheckBlock)();

OBJC_EXTERN NSTimeInterval const kFRYEventDispatchInterval;

#define FRY_KEYPATH(c, p) ({\
c *object __unused; \
typeof(object.p) property __unused; \
@#p; \
})

#define FRY_APP [UIApplication sharedApplication]
#define FRY_KEY_WINDOW [[UIApplication sharedApplication] keyWindow]

typedef NS_ENUM(NSInteger, FRYDirection) {
    FRYDirectionUp = 1,
    FRYDirectionDown,
    FRYDirectionRight,
    FRYDirectionLeft
};

@class FRYQuery;

typedef FRYQuery *(^FRYChainBlock)(id predicateOrArrayOfPredicates);
typedef FRYQuery *(^FRYChainStringBlock)(NSString *string);
typedef FRYQuery *(^FRYChainVoidBlock)();
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYSearchBlock)(NSInteger FRYDirection, NSPredicate *content);
typedef BOOL(^FRYLookupBlock)(NSPredicate *content);
typedef BOOL(^FRYIntCheckBlock)(NSUInteger count);

typedef BOOL(^FRYBoolResultsBlock)(NSSet *);
typedef BOOL(^FRYBoolCallbackBlock)(NSString *message, FRYBoolResultsBlock check);
