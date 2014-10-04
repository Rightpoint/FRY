//
//  UIAccessibilityElement+FRY.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAccessibilityElement (FRY)

- (NSString *)fry_accessibilityLabel;
- (NSString *)id_accessibilityValue;

- (UIView *)id_containingView;

@end
