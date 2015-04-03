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
    FRY.lookupByAccessibilityLabel(@"One").tap();
    FRY.lookupByAccessibilityLabel(@"Select = One").present();

    UIPickerView *inputPicker = (id)FRY.lookup(FRY_ofKind([UIPickerView class])).shallow().view;
    XCTAssertNotNil(inputPicker);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"44" inComponent:0 animated:YES]);
    
    FRY.lookupByAccessibilityLabel(@"Picker = 44 / 0").present();

    XCTAssertTrue([inputPicker fry_selectTitle:@"99" inComponent:0 animated:YES]);
    FRY.lookupByAccessibilityLabel(@"Picker = 99 / 0").present();
}

- (void)testPickerTwo
{
    FRY.lookupByAccessibilityLabel(@"Two").tap();
    FRY.lookupByAccessibilityLabel(@"Select = Two").present();
   
    UIPickerView *inputPicker = (id)FRY.lookup(FRY_ofKind([UIPickerView class])).shallow().view;
    XCTAssertNotNil(inputPicker);
    
    XCTAssertTrue([inputPicker fry_selectTitle:@"44" inComponent:0 animated:YES]);
    
    FRY.lookupByAccessibilityLabel(@"Picker = 44 / 0").present();

    XCTAssertTrue([inputPicker fry_selectTitle:@"99" inComponent:1 animated:YES]);
    
    FRY.lookupByAccessibilityLabel(@"Picker = 99 / 1").present();
}

@end
