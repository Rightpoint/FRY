//
//  FRYDefines.h
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FRYVoidBlock)(void);

typedef void(^FRYInteractionBlock)(NSArray *lookupResults);
typedef void(^FRYFirstMatchBlock)(UIView *view, CGRect frameInView);

typedef BOOL(^FRYCheckBlock)();

OBJC_EXTERN NSTimeInterval const kFRYEventDispatchInterval;


#define FRY_APP [UIApplication sharedApplication]
#define FRY_KEY [[UIApplication sharedApplication] keyWindow]