//
//  TextFieldViewControllerTests.m
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRY.h"
#import "TextFieldViewController.h"

@interface TextFieldViewControllerTests : XCTestCase

@property (strong, nonatomic) TextFieldViewController *viewController;

@end

@implementation TextFieldViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [[TextFieldViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];

    //    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:450000]];
}

- (void)tearDown {
    if ([[FRYTouchDispatch shared] hasActiveTouches]) {
        [[FRYTouchDispatch shared] clearInteractionsAndTouches];
        XCTAssertFalse(YES);
    }
    
    [super tearDown];
}

- (void)testTapByPlaceholder
{
    FRY_KEY.accessibilityLabel(@"placeholder").tap();

    
    NSArray *stringsToTest = @[
                               @"Tt8/*",
                               @"Thissss is text",
                               @"8 * 8 /",
// This is buggy.  issue #5
                               @"VERYLONGTEXTWITHMANYUPPERCASELETTERS",
                               ];
    for ( NSString *string in stringsToTest ) {
        [FRYTypist typeString:string];

        FRY_KEY.accessibilityValue(string).present().selectText();
    }
}

/**
 *  This test takes entirely too long to run, and will be commented out.
 *  Make sure you execute it if any typing code is changed.
 */
//- (void)testTypingEntirelyTooMuch
//{
//    FRY_KEY.accessibilityLabel(@"placeholder").depthFirst().tap();
//    
//    FRYTypist *typist = [[UIApplication sharedApplication] fry_typist];
//
//    NSArray *stringsToTest = @[
//                               @"Tt8/*",
//                               @"Thissss is text",
//                               @"8 * 8 /",
//                               @"VERYLONGTEXTWITHMANYUPPERCASELETTERS",
//                               ];
//    for ( NSUInteger i = 0; i < 50; i++ ) {
//        for ( NSString *string in stringsToTest ) {
//            [typist typeString:string];
//            
//            FRY_KEY.accessibilityValue(string).depthFirst().present().selectText();
//        }
//    }
//}

@end
