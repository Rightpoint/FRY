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

@class FRYDSL;
@class FRYTouch;
@class FRYDSLResult;

typedef FRYDSL *(^FRYDSLStringBlock)(NSString *);
typedef FRYDSL *(^FRYDSLClassBlock)(Class);
typedef FRYDSL *(^FRYDSLPredicateBlock)(NSPredicate *);

typedef FRYDSLResult *(^FRYDSLBlock)();


@interface FRYDSL : NSObject

- (id)initForAppWithTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;
- (id)initForKeyWindowWithTestTarget:(id)target inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;


@property (copy, nonatomic, readonly) FRYDSLStringBlock accessibilityLabel;
@property (copy, nonatomic, readonly) FRYDSLStringBlock accessibilityValue;
@property (copy, nonatomic, readonly) FRYDSLClassBlock ofClass;
@property (copy, nonatomic, readonly) FRYDSLPredicateBlock matching;

@property (copy, nonatomic, readonly) FRYDSLBlock all;
@property (copy, nonatomic, readonly) FRYDSLBlock depthFirst;

@end



#define FRYD [[FRYDSL alloc] initForAppWithTestTarget:self inFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__]
#define FRYD_KEY [[FRYDSL alloc] initForKeyWindowWithTestTarget:self inFile:[NSString stringWithUTF8String:__FILE__] atLine:__LINE__]

