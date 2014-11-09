//
//  UITextInput+FRY.m
//  FRY
//
//  Created by Brian King on 10/31/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UITextInput+FRY.h"

@implementation UITextField(FRY)

- (void)fry_selectAll;
{
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *end   = self.endOfDocument;
    UITextRange *allText  = [self textRangeFromPosition:begin toPosition:end];
    
    [self setSelectedTextRange:allText];
}

@end

@implementation UITextView(FRY)

- (void)fry_selectAll;
{
    UITextPosition *begin = self.beginningOfDocument;
    UITextPosition *end   = self.endOfDocument;
    UITextRange *allText  = [self textRangeFromPosition:begin toPosition:end];
    
    [self setSelectedTextRange:allText];
}


@end
