//
//  FRYDSL.h
//  FRY
//
//  Created by Brian King on 11/14/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FRYDefines.h"
#import "FRYLookup.h"

@class FRYDSLQuery;
@class FRYTouch;
@class FRYDSLResult;

typedef FRYDSLQuery *(^FRYDSLStringBlock)(NSString *);
typedef FRYDSLQuery *(^FRYDSLTraitsBlock)(UIAccessibilityTraits);
typedef FRYDSLQuery *(^FRYDSLClassBlock)(Class);
typedef FRYDSLQuery *(^FRYDSLPredicateBlock)(NSPredicate *);
typedef FRYDSLQuery *(^FRYDSLIndexPathBlock)(NSIndexPath *);

typedef FRYDSLResult *(^FRYDSLBlock)();


@interface FRYDSLQuery : NSObject

- (id)initForLookup:(id<FRYLookup>)lookupOrigin withTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;

@property (strong, nonatomic, readonly) id<FRYLookup> lookupOrigin;
@property (strong, nonatomic, readonly) id testTarget;
@property (copy,   nonatomic, readonly) NSString *filename;
@property (assign, nonatomic, readonly) NSUInteger lineNumber;

- (NSPredicate *)predicate;
- (NSSet *)performQuery;


@property (copy, nonatomic, readonly) FRYDSLStringBlock accessibilityLabel;
@property (copy, nonatomic, readonly) FRYDSLStringBlock accessibilityValue;
@property (copy, nonatomic, readonly) FRYDSLTraitsBlock accessibilityTraits;
@property (copy, nonatomic, readonly) FRYDSLClassBlock ofClass;
@property (copy, nonatomic, readonly) FRYDSLIndexPathBlock atIndexPath;
@property (copy, nonatomic, readonly) FRYDSLPredicateBlock matching;

@property (copy, nonatomic, readonly) FRYDSLBlock all;
@property (copy, nonatomic, readonly) FRYDSLBlock depthFirst;

@end


#define FRYQ(view) [[FRYDSLQuery alloc] initForLookup:view withTestTarget:self inFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__]
#define FRY        FRYQ([UIApplication sharedApplication])
#define FRY_KEY    FRYQ([[UIApplication sharedApplication] keyWindow])

