//
//  UITextInput+FRY.h
//  FRY
//
//  Created by Brian King on 10/31/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField(FRY)

/**
 *  Helper method to select all text in a UITextField
 */
- (void)fry_selectAll;

@end

@interface UITextView(FRY)

/**
 *  Helper method to select all text in a UITextView
 */
- (void)fry_selectAll;

@end
