//
//  PickerViewControllerTests.m
//  FRY
//
//  Created by Brian King on 11/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FRY/FRY.h>

#import "PickerViewController.h"

@interface PickerViewControllerTests : XCTestCase

@property (strong, nonatomic) PickerViewController *viewController;

@end

@implementation PickerViewControllerTests

- (void)setUp
{
    [super setUp];
    self.viewController = [[PickerViewController alloc] initWithNibName:nil bundle:nil];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

- (void)testPickerOne
{
    FRY.lookupFirstByAccessibilityLabel(@"One").tap();
    FRY.lookupFirstByAccessibilityLabel(@"Select = One").present();

    UIPickerView *inputPicker = (id)[FRY_APP fry_inputViewOfClass:[UIPickerView class]];
    XCTAssertNotNil(inputPicker);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"44" inComponent:0 animated:YES]);
    
    FRY.lookupFirstByAccessibilityLabel(@"Picker = 44 / 0").present();

    XCTAssertTrue([inputPicker fry_selectTitle:@"99" inComponent:0 animated:YES]);
    FRY.lookupFirstByAccessibilityLabel(@"Picker = 99 / 0").present();
}

- (void)testPickerTwo
{
    FRY.lookupFirstByAccessibilityLabel(@"Two").tap();
    FRY.lookupFirstByAccessibilityLabel(@"Select = Two").present();
   
    UIPickerView *inputPicker = (id)[FRY_APP fry_inputViewOfClass:[UIPickerView class]];
    XCTAssertNotNil(inputPicker);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"44" inComponent:0 animated:YES]);
    
    FRY.lookupFirstByAccessibilityLabel(@"Picker = 44 / 0").present();

    XCTAssertTrue([inputPicker fry_selectTitle:@"99" inComponent:1 animated:YES]);
    
    FRY.lookupFirstByAccessibilityLabel(@"Picker = 99 / 1").present();
}

@end
