//
//  PickerViewController.m
//  FRY
//
//  Created by Brian King on 11/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "PickerViewController.h"

typedef NS_ENUM(NSInteger, PickerViewControllerInput) {
    PickerViewControllerInputDate,
    PickerViewControllerInputTime,
    PickerViewControllerInputDateTime,
    PickerViewControllerInputOneComponent,
    PickerViewControllerInputTwoComponents
};

@interface PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *inputTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *onePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *twoPicker;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;
@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;

@property (assign, nonatomic) PickerViewControllerInput inputType;

@end

@implementation PickerViewController

+ (NSString *)pickerViewControllerLabel:(PickerViewControllerInput)inputType
{
    NSString *label = nil;
    switch ( inputType ) {
        case PickerViewControllerInputDate:
            label = @"Date";
            break;
        case PickerViewControllerInputTime:
            label = @"Time";
            break;
        case PickerViewControllerInputDateTime:
            label = @"DT";
            break;
        case PickerViewControllerInputOneComponent:
            label = @"One";
            break;
        case PickerViewControllerInputTwoComponents:
            label = @"Two";
            break;
        default:
            break;
    }
    return label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inputType = PickerViewControllerInputDate;
    self.datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.dateTimePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.timePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    self.dateTimeFormatter.timeStyle = NSDateFormatterShortStyle;
    self.dateTimeFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateTimeFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];

    self.timeFormatter = [[NSDateFormatter alloc] init];
    self.timeFormatter.timeStyle = NSDateFormatterShortStyle;
    self.timeFormatter.dateStyle = NSDateFormatterNoStyle;
    self.timeFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
}

-  (void)setInputType:(PickerViewControllerInput)inputType
{
    if ( [self isFirstResponder] ) {
        [self resignFirstResponder];
    }
    _inputType = inputType;
    self.statusLabel.text = [NSString stringWithFormat:@"Select = %@",
                             [self.class pickerViewControllerLabel:inputType]];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}

- (UIView *)inputView
{
    UIView *inputView;
    switch ( self.inputType ) {
        case PickerViewControllerInputDate:
            inputView = self.datePicker;
            break;
        case PickerViewControllerInputTime:
            inputView = self.timePicker;
            break;
        case PickerViewControllerInputDateTime:
            inputView = self.dateTimePicker;
            break;
        case PickerViewControllerInputOneComponent:
            inputView = self.onePicker;
            break;
        case PickerViewControllerInputTwoComponents:
            inputView = self.twoPicker;
        default:
            break;
    }
    return inputView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (IBAction)inputTypeChange:(UISegmentedControl *)sender
{
    self.inputType = sender.selectedSegmentIndex;
}

- (IBAction)dateChange:(UIDatePicker *)datePicker
{
    self.statusLabel.text = [NSString stringWithFormat:@"Date = %@", [self.dateFormatter stringFromDate:datePicker.date]];
}

- (IBAction)dateTimeChange:(UIDatePicker *)datePicker
{
    self.statusLabel.text = [NSString stringWithFormat:@"Date Time = %@", [self.dateTimeFormatter stringFromDate:datePicker.date]];
}

- (IBAction)timeChange:(UIDatePicker *)datePicker
{
    self.statusLabel.text = [NSString stringWithFormat:@"Time = %@", [self.timeFormatter stringFromDate:datePicker.date]];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ( self.inputType == PickerViewControllerInputOneComponent ) {
        return 1;
    }
    else  {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 100;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%zd", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.statusLabel.text = [NSString stringWithFormat:@"Picker = %zd / %zd", row, component];
}

@end
