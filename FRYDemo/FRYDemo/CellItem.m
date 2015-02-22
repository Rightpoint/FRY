//
//  CellItem.m
//  FRY
//
//  Created by Brian King on 11/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "CellItem.h"

@implementation CellItem

+ (instancetype)itemWithTitle:(NSString *)title block:(CellItemAction)block
{
    CellItem *item = [[CellItem alloc] init];
    item.title = title;
    item.block = block;

    return item;
}

@end
