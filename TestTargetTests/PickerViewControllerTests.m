//
//  PickerViewControllerTests.m
//  FRY
//
//  Created by Brian King on 11/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRY.h"
#import "PickerViewController.h"

@interface PickerViewControllerTests : XCTestCase

@property (strong, nonatomic) PickerViewController *viewController;

@end

@implementation PickerViewControllerTests

- (void)setUp {
    [super setUp];
    self.viewController = [[PickerViewController alloc] initWithNibName:nil bundle:nil];
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

- (void)testPickerOne
{
    FRYD_KEY.accessibilityLabel(@"One").depthFirst().tap();
    FRYD_KEY.accessibilityLabel(@"Select = One").all().present();

#warning This API still sucks.  Doesn't use / integrate with DSL well.
    UIPickerView *inputPicker = (id)[FRY_APP fry_inputViewOfClass:[UIPickerView class]];
    XCTAssertNotNil(inputPicker);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"44" inComponent:0 animated:YES]);
    
    XCTAssertNotNil([FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Picker = 44 / 0"]]);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"99" inComponent:0 animated:YES]);
    
    XCTAssertNotNil([FRY_KEY fry_farthestDescendentMatching:[NSPredicate fry_matchAccessibilityLabel:@"Picker = 99 / 0"]]);
}

- (void)testPickerTwo
{
    FRYD_KEY.accessibilityLabel(@"Two").depthFirst().tap();
    FRYD_KEY.accessibilityLabel(@"Select = Two").all().present();
   
    UIPickerView *inputPicker = (id)[FRY_APP fry_inputViewOfClass:[UIPickerView class]];
    XCTAssertNotNil(inputPicker);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"44" inComponent:0 animated:YES]);
    
    FRYD_KEY.accessibilityLabel(@"Picker = 44 / 0").all().present();

    XCTAssertTrue([inputPicker fry_selectTitle:@"99" inComponent:1 animated:YES]);
    
    FRYD_KEY.accessibilityLabel(@"Picker = 99 / 1").all().present();
}

@end
