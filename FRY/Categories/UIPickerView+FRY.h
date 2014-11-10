//
//  UIPickerView+FRY.h
//  FRY
//
//  Created by Brian King on 11/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPickerView (FRY)

- (BOOL)fry_selectTitle:(NSString *)title inComponent:(NSUInteger)componentIndex animated:(BOOL)animated;

@end
