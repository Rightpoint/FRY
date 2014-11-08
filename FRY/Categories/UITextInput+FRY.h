//
//  UITextInput+FRY.h
//  FRY
//
//  Created by Brian King on 10/31/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This is not very authentic text input, but is a place holder until
 * more accurate typing can be done.
 */
@interface UITextField(FRY)

- (void)fry_replaceTextWithString:(NSString *)string;

@end

@interface UITextView(FRY)

- (void)fry_replaceTextWithString:(NSString *)string;

@end
