//
//  CellItem.h
//  FRY
//
//  Created by Brian King on 11/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CellItemAction)(void);

@interface CellItem : NSObject

+ (instancetype)itemWithTitle:(NSString *)title block:(CellItemAction)block;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) CellItemAction block;

@end
