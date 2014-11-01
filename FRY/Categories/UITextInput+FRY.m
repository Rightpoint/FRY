//
//  UITextInput+FRY.m
//  FRY
//
//  Created by Brian King on 10/31/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UITextInput+FRY.h"

@implementation UITextField(FRY)

- (void)fry_replaceTextWithString:(NSString *)string
{
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *end   = self.endOfDocument;
    UITextRange *allText  = [self textRangeFromPosition:begin toPosition:end];
    NSString *currentText = [self textInRange:allText];
    NSRange range = NSMakeRange(0, [currentText length]);
    if ( [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)] &&
         [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string] ) {
        [self replaceRange:allText withText:string];
    }
}

@end

@implementation UITextView(FRY)

- (void)fry_replaceTextWithString:(NSString *)string
{
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *end   = self.endOfDocument;
    UITextRange *allText  = [self textRangeFromPosition:begin toPosition:end];
    NSString *currentText = [self textInRange:allText];
    NSRange range = NSMakeRange(0, [currentText length]);

    if ( [self respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)] &&
         [self.delegate textView:self shouldChangeTextInRange:range replacementText:string] ) {
        [self replaceRange:allText withText:string];
    }
}

@end
