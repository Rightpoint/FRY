//
//  FRYQueryContext.m
//  FRY
//
//  Created by Brian King on 3/29/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

#import "FRYQueryContext.h"

@interface NSException (SenTestStub)
+ (NSException *)failureInFile:(NSString *)filename atLine:(int)lineNumber withDescription:(NSString *)formatString, ...;
@end

@interface NSObject(SenTestStub)
- (void)failWithException:(NSException *)exception;
@end

@interface NSObject(XCTestStub)
- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filename atLine:(NSUInteger)lineNumber expected:(BOOL)expected;
@end

static NSString *const FRYQueryContextError = @"FRY Error";

@implementation FRYQueryContext

- (id)initWithTestTarget:(id)testTarget inFile:(NSString *)filename atLine:(NSUInteger)lineNumber;
{
    self = [super init];
    if ( self ) {
        _testTarget = testTarget;
        _filename = [filename copy];
        _lineNumber = lineNumber;
    }
    return self;
}

- (void)recordFailureWithMessage:(NSString *)message action:(FRYQuery *)action results:(NSSet *)results;
{
    NSString *description = [NSString stringWithFormat:@"\nMessage:%@\nAction:%@\nResults:%@\n", message, action, results];
    if ( self.testTarget && [self.testTarget respondsToSelector:@selector(recordFailureWithDescription:inFile:atLine:expected:)] ) {
        [self.testTarget recordFailureWithDescription:description inFile:self.filename atLine:self.lineNumber expected:YES];
    }
    else if ( self.testTarget && [self.testTarget respondsToSelector:@selector(failWithException:)]) {
        NSException *exception = [NSException failureInFile:self.filename atLine:(int)self.lineNumber withDescription:description];
        [self.testTarget failWithException:exception];
    }
    else {
        NSString *reason = [NSString stringWithFormat:@"%@:%zd %@", self.filename, self.lineNumber, description];
        NSException *exception = [NSException exceptionWithName:FRYQueryContextError reason:reason userInfo:nil];
        [exception raise];
    }
}

@end
