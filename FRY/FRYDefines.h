//
//  FRYDefines.h
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FRYInteractionBlock)(NSArray *lookupResults);

typedef NS_ENUM(NSInteger, FRYTargetWindow) {
    FRYTargetWindowKey = 0,
    FRYTargetWindowKeyboard,
    FRYTargetWindowAll,
};

