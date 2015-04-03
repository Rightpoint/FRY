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

#define FRY_PREDICATE_KEYPATH(cls, p, cmp, v) ({\
[NSCompoundPredicate andPredicateWithSubpredicates:@[\
[NSPredicate fry_matchClass:[cls class]],\
FRY_PREDICATE_KEYPATH_ONLY(cls, p, cmp, v)\
]];\
})

#define FRY_PREDICATE_KEYPATH_ONLY(cls, p, cmp, v) ({\
if ( 0 cmp 0 ) {}\
NSString *format = [NSString stringWithFormat:@"%@ %@ %@", @"%K", @#cmp, @"%@"];\
[NSPredicate predicateWithFormat:format, FRY_KEYPATH(cls, p), v];\
})

#define FRY_PREDICATE_SELECTOR(c, sel, v) ({\
[NSCompoundPredicate andPredicateWithSubpredicates:@[\
[NSPredicate fry_matchClass:[c class]],\
FRY_PREDICATE_SELECTOR_ONLY(c, sel, v)\
]];\
})

#define FRY_PREDICATE_SELECTOR_ONLY(c, sel, v) ({\
c *obj;\
if ( 0 ) { [obj sel v]; }\
NSString *format = [NSString stringWithFormat:@"SELF %@ %@", @#sel, @"%@"];\
[NSPredicate predicateWithFormat:format, v];\
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

typedef FRYQuery *(^FRYChainPredicateBlock)(id predicateOrArrayOfPredicates);
typedef FRYQuery *(^FRYChainStringBlock)(NSString *string);
typedef FRYQuery *(^FRYChainBlock)();
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYSearchBlock)(FRYDirection FRYDirection, NSPredicate *content);
typedef BOOL(^FRYLookupBlock)(NSPredicate *content);
typedef BOOL(^FRYIntCheckBlock)(NSUInteger count);

typedef BOOL(^FRYBoolResultsBlock)(NSSet *);
typedef BOOL(^FRYBoolCallbackBlock)(NSString *message, FRYBoolResultsBlock check);
