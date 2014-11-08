//
//  FRYDefines.h
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FRYMatchBlock)(UIView *view, CGRect frameInView);

typedef BOOL(^FRYCheckBlock)();
typedef NSString *(^FRYCheckFailureExplaination)();

OBJC_EXTERN NSTimeInterval const kFRYEventDispatchInterval;
OBJC_EXTERN NSString *kFRYCheckFailedExcetion;


#define FRY_APP [UIApplication sharedApplication]
#define FRY_KEY [[UIApplication sharedApplication] keyWindow]