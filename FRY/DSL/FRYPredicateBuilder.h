//
//  FRYPredicateBuilder.h
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRYPredicateBuilder;

typedef FRYPredicateBuilder *(^FRYDSLStringBlock)(NSString *);
typedef FRYPredicateBuilder *(^FRYDSLTraitsBlock)(UIAccessibilityTraits);
typedef FRYPredicateBuilder *(^FRYDSLClassBlock)(Class);
typedef FRYPredicateBuilder *(^FRYDSLPredicateBlock)(NSPredicate *);
typedef FRYPredicateBuilder *(^FRYDSLIndexPathBlock)(NSIndexPath *);

@protocol FRYPredicate <NSObject>

- (BOOL)evaluateWithObject:(id)object;

@end

#define where(cmd) ({\
FRYPredicateBuilder *builder = [FRYPredicateBuilder builder];\
builder.cmd;\
[builder predicate];\
})

@interface FRYPredicateBuilder : NSObject
+ (FRYPredicateBuilder *)builder;
@property (copy, nonatomic, readonly) FRYDSLStringBlock a11yLabel;
@property (copy, nonatomic, readonly) FRYDSLStringBlock a11yValue;
@property (copy, nonatomic, readonly) FRYDSLTraitsBlock a11yTraits;
@property (copy, nonatomic, readonly) FRYDSLClassBlock ofClass;
@property (copy, nonatomic, readonly) FRYDSLIndexPathBlock atIndexPath;
@property (copy, nonatomic, readonly) FRYDSLIndexPathBlock rowAtIndexPath;
@property (copy, nonatomic, readonly) FRYDSLIndexPathBlock itemAtIndexPath;
@property (copy, nonatomic, readonly) FRYDSLPredicateBlock matching;

- (NSPredicate *)predicate;

- (BOOL)evaluateWithObject:(id)object;

@end

@interface NSPredicate(FRYPredicateBuilder) <FRYPredicate>

@end