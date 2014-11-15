//
//  UIPickerView+FRY.m
//  FRY
//
//  Created by Brian King on 11/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "UIPickerView+FRY.h"

@implementation UIPickerView (FRY)

- (BOOL)fry_selectTitle:(NSString *)title inComponent:(NSUInteger)componentIndex animated:(BOOL)animated
{
    NSAssert(componentIndex < [self.dataSource numberOfComponentsInPickerView:self], @"Invalid component");
    NSAssert([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)], @"Can only selectTitle if it delegate responds to pickerView:titleForRow:forComponent:");
    BOOL found = NO;
    NSInteger rowCount = [self.dataSource pickerView:self numberOfRowsInComponent:componentIndex];
    for (NSInteger rowIndex = 0; rowIndex < rowCount; rowIndex++) {
        NSString *rowTitle = [self.delegate pickerView:self titleForRow:rowIndex forComponent:componentIndex];
        if ([rowTitle isEqual:title])
        {
            [self selectRow:rowIndex inComponent:componentIndex animated:animated];
            
            if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
            {
                [self.delegate pickerView:self didSelectRow:rowIndex inComponent:componentIndex];
            }
            found = YES;
        }
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.7]];

    return found;
}

@end
