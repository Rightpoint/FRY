//
//  FRYDSLResult.h
//  FRY
//
//  Created by Brian King on 11/14/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYDSL.h"

@class FRYDSLResult;
@class FRYTouch;

typedef FRYDSLResult *(^FRYDSLArrayBlock)(NSArray *);
typedef FRYDSLResult *(^FRYDSLResultStringBlock)(NSString *);
typedef FRYDSLResult *(^FRYDSLTouchBlock)(FRYTouch *);
typedef FRYDSLResult *(^FRYDSLIntegerBlock)(NSInteger);
typedef FRYDSLResult *(^FRYDSLMatchBlock)(UIView *view, CGRect frameInView);


@interface FRYDSLResult : NSObject

- (id)initWithResults:(NSSet *)results testCase:(id)testCase inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;

@property (copy, nonatomic, readonly) FRYDSLBlock present;
@property (copy, nonatomic, readonly) FRYDSLBlock absent;
@property (copy, nonatomic, readonly) FRYDSLIntegerBlock count;

@property (copy, nonatomic, readonly) FRYDSLBlock tap;
@property (copy, nonatomic, readonly) FRYDSLTouchBlock touch;
@property (copy, nonatomic, readonly) FRYDSLArrayBlock touches;
@property (copy, nonatomic, readonly) UIView *view;

@property (copy, nonatomic, readonly) FRYDSLBlock selectText;
@property (copy, nonatomic, readonly) FRYDSLResultStringBlock type;

@end
