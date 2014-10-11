//
//  Test_HostTests.m
//  Test HostTests
//
//  Created by Brian King on 10/7/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRY.h"

@interface Test_HostTests : XCTestCase


@end

@implementation Test_HostTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [[FRY shared] clearInteractionsAndTouches];
    [super tearDown];
}

- (void)testExample {
    [[FRY shared] findViewsMatching:@{kFRYLookupAccessibilityLabel : @"Tapping"}
                          whenFound:^(NSArray *lookupResults) {
                              NSLog(@"Found %@", lookupResults);
                          }];
    [[FRY shared] performAllLookups];
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
