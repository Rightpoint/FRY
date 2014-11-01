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
    BOOL shouldReplace = YES;
    if ( [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)] ) {
        shouldReplace = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
    }
    if ( shouldReplace ) {
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
    BOOL shouldReplace = YES;
    if ( [self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)] ) {
        shouldReplace = [self.delegate textView:self shouldChangeTextInRange:range replacementText:string];
    }
    if ( shouldReplace ) {
        [self replaceRange:allText withText:string];
    }

}

@end
