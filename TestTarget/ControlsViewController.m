//
//  ControlsViewController.m
//  FRY
//
//  Created by Brian King on 11/2/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "ControlsViewController.h"

@interface ControlsViewController ()

@property (strong, nonatomic) NSMutableSet *triggeredSelectors;

- (IBAction)segmentControlAction:(UISegmentedControl *)sender;

- (IBAction)stepperAction:(UIStepper *)sender;

- (IBAction)sliderAction:(UISlider *)sender;
- (IBAction)switchAction:(UISwitch *)sender;

@end

@implementation ControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.triggeredSelectors = [NSMutableSet set];

    self.slider.accessibilityLabel = @"Slider";
    self.stepper.accessibilityLabel = @"Stepper";
    self.switchControl.accessibilityLabel = @"Switch";
    self.toolbarSwitchControl.accessibilityLabel = @"toolbar switch";
}

- (UINavigationItem *)navigationItem
{
    UINavigationItem *ni = [super navigationItem];
    return ni;
}

#define IBACTION_COUNT 6

- (void)updateProgressForSelector:(SEL)selector
{
    [self.triggeredSelectors addObject:NSStringFromSelector(selector)];
    self.progressView.progress = self.triggeredSelectors.count / (float)IBACTION_COUNT;
}

- (void)updateLastAction:(NSString *)lastAction
{
    self.segmentStatusLabel.text = [NSString stringWithFormat:@"Action=%@", lastAction];
}

- (IBAction)segmentControlAction:(UISegmentedControl *)sender
{
    [self updateProgressForSelector:_cmd];
    [self updateLastAction:[sender titleForSegmentAtIndex:sender.selectedSegmentIndex]];
}

- (IBAction)stepperAction:(UIStepper *)sender
{
    [self updateProgressForSelector:_cmd];
    [self updateLastAction:@"Stepper"];

    self.slider.value = sender.value;
    self.sliderStatusLabel.text = [NSString stringWithFormat:@"Slider=%.0f",
                                   sender.value];
}

- (IBAction)sliderAction:(UISlider *)sender
{
    [self updateProgressForSelector:_cmd];
    [self updateLastAction:@"Slider"];

    self.stepper.value = sender.value;
    self.sliderStatusLabel.text = [NSString stringWithFormat:@"Slider=%.0f",
                                   sender.value];
}

- (IBAction)switchAction:(UISwitch *)sender
{
    [self updateProgressForSelector:_cmd];
    [self updateLastAction:sender.accessibilityLabel];

    if ( sender == self.switchControl ) {
        if ( self.switchControl.isOn ) {
            [self.activityIndicator startAnimating];
        }
        else {
            [self.activityIndicator stopAnimating];
        }
    }
}

- (IBAction)itemAction:(UIBarButtonItem *)sender
{
    [self updateLastAction:[sender title]];
    [self updateProgressForSelector:_cmd];
}

- (IBAction)buttonAction:(UIButton *)sender
{
    [self updateLastAction:[sender.titleLabel text]];
    [self updateProgressForSelector:_cmd];
}
@end
