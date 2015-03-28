//
//  FRYActionBuilder.h
//  FRY
//
//  Created by Brian King on 3/23/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FRYLookup.h"
#import "FRYPredicateBuilder.h"

@class FRYAction;

typedef FRYAction *(^FRYChainBlock)(NSPredicate *predicate);
typedef BOOL(^FRYTouchBlock)(id touchOrArrayOfTouches);
typedef BOOL(^FRYDirectionBlock)(NSUInteger FRYDirection);
typedef BOOL(^FRYCheckBlock)();
typedef BOOL(^FRYCountBlock)(NSUInteger count);


#define FRY2 ({[FRYAction actionFrom:[UIApplication sharedApplication];})


FRYAction *lookup(id<FRYPredicate> );
FRYAction *lookupFirst(id<FRYPredicate> nspredicateOrPredicateBuilder);

@interface FRYAction : NSObject

+ (FRYAction *)actionFrom:(id<FRYLookup>)lookupRoot;

@property (copy, nonatomic, readonly) FRYChainBlock lookup;
@property (copy, nonatomic, readonly) FRYChainBlock lookupFirst;

@property (copy, nonatomic, readonly) FRYTouchBlock touch;
@property (copy, nonatomic, readonly) FRYDirectionBlock scroll;
@property (copy, nonatomic, readonly) FRYCheckBlock selectText;

@property (copy, nonatomic, readonly) FRYCheckBlock present;
@property (copy, nonatomic, readonly) FRYCheckBlock absent;
@property (copy, nonatomic, readonly) FRYCountBlock count;

@property (copy, nonatomic, readonly) NSArray *views;

@end
