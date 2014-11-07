//
//  ControlsViewController.h
//  FRY
//
//  Created by Brian King on 11/2/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *toolbarSegmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *momentarySegmentControl;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UISwitch *toolbarSwitchControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *segmentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sliderStatusLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolbarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *toolbarButton;

@end
