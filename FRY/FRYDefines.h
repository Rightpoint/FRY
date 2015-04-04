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

/**
 * Return a compile-checked keypath.
 */
#define FRY_KEYPATH(c, p) ({\
c *object __unused; \
typeof(object.p) property __unused; \
@#p; \
})

/**
 * Return a compiler-checked predicate that checks that the object is kind of
 * class(cls) and that the keypath compares(cmp) to the value(v)
 */
#define FRY_PREDICATE_KEYPATH(cls, p, cmp, v) ({\
[NSCompoundPredicate andPredicateWithSubpredicates:@[\
FRY_PREDICATE_SELECTOR_ONLY(NSObject, isKindOfClass:, [cls class]),\
FRY_PREDICATE_KEYPATH_ONLY(cls, p, cmp, v)\
]];\
})

/**
 *  Return a compiler-checked predicate that checks that the value for the
 *  keypath compares(cmp) to the value(v)
 */
#define FRY_PREDICATE_KEYPATH_ONLY(cls, p, cmp, v) ({\
if ( 0 cmp 0 ) {}\
NSString *format = [NSString stringWithFormat:@"%@ %@ %@", @"%K", @#cmp, @"%@"];\
[NSPredicate predicateWithFormat:format, FRY_KEYPATH(cls, p), v];\
})

/**
 *  Return a compiler-checked predicate that checks that the object is kind of
 *  class(cls) and that the selector(sel) when invoked with the argument(v) returns true
 */
#define FRY_PREDICATE_SELECTOR(cls, sel, v) ({\
[NSCompoundPredicate andPredicateWithSubpredicates:@[\
FRY_PREDICATE_SELECTOR_ONLY(NSObject, isKindOfClass:, [cls class]),\
FRY_PREDICATE_SELECTOR_ONLY(cls, sel, v)\
]];\
})

/**
 *  Return a compiler-checked predicate that checks that the selector(sel) when 
 *  invoked with the argument(v) returns true
 */
#define FRY_PREDICATE_SELECTOR_ONLY(cls, sel, v) ({\
cls *obj;\
if ( 0 ) { [obj sel v]; }\
NSString *format = [NSString stringWithFormat:@"SELF %@ %@", @#sel, @"%@"];\
[NSPredicate predicateWithFormat:format, v];\
})

/**
 * Return a compiler-checked predicate that checks that the the keypath(p) & value(v) == value(v)
 */
#define FRY_PREDICATE_KEYPATH_HAS_FLAG(cls, p, v) ({\
[NSPredicate predicateWithFormat:@"(%K & %@) == %@", FRY_KEYPATH(cls, p), @(v), @(v)];\
})

/**
 * Configure some shorthand macro's for common predicates
 */
#ifdef FRY_SHORTHAND
#define ofKind(cls) FRY_PREDICATE_SELECTOR_ONLY(NSObject, isKindOfClass:, cls)
#define isOnScreen(onScreen) FRY_PREDICATE_KEYPATH(NSObject, fry_isOnScreen, ==, @(onScreen))
#define isAnimating(animating) FRY_PREDICATE_KEYPATH(NSObject, fry_isAnimating, ==, @(animating))
#define accessibilityLabel(label) FRY_PREDICATE_KEYPATH(NSObject, fry_accessibilityLabel, ==, label)
#define accessibilityValue(value) FRY_PREDICATE_KEYPATH(NSObject, fry_accessibilityValue, ==, value)
#define accessibilityTrait(trait) FRY_PREDICATE_KEYPATH_HAS_FLAG(UIView, accessibilityTraits, trait)
#define atIndexPath(indexPath) FRY_PREDICATE_KEYPATH(UIView, fry_indexPathInContainer, ==, indexPath)
#define atSectionAndRow(s, r) FRY_PREDICATE_KEYPATH(UIView, fry_indexPathInContainer, ==, [NSIndexPath indexPathForRow:r inSection:s])
#else
#define FRY_ofKind(cls) FRY_PREDICATE_SELECTOR_ONLY(NSObject, isKindOfClass:, cls)
#define FRY_isOnScreen(onScreen) FRY_PREDICATE_KEYPATH(NSObject, fry_isOnScreen, ==, @(onScreen))
#define FRY_isAnimating(animating) FRY_PREDICATE_KEYPATH(NSObject, fry_isAnimating, ==, @(animating))
#define FRY_accessibilityLabel(label) FRY_PREDICATE_KEYPATH(NSObject, fry_accessibilityLabel, ==, label)
#define FRY_accessibilityValue(value) FRY_PREDICATE_KEYPATH(NSObject, fry_accessibilityValue, ==, value)
#define FRY_accessibilityTrait(trait) FRY_PREDICATE_KEYPATH_HAS_FLAG(UIView, accessibilityTraits, trait)
#define FRY_atIndexPath(indexPath) FRY_PREDICATE_KEYPATH(UIView, fry_indexPathInContainer, ==, indexPath)
#define FRY_atSectionAndRow(s, r) FRY_PREDICATE_KEYPATH(UIView, fry_indexPathInContainer, ==, [NSIndexPath indexPathForRow:r inSection:s])
#endif

typedef NS_ENUM(NSInteger, FRYDirection) {
    FRYDirectionUp = 1,
    FRYDirectionDown,
    FRYDirectionRight,
    FRYDirectionLeft
};

