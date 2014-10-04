//
//  TouchDispatch.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYToucher.h"

@interface FRYTouchSynthesisOperation : NSOperation

+ (FRYTouchSynthesisOperation *)shared;

@property (strong) FRYToucher *toucher;
@property (assign) NSTimeInterval minimumEventDelay;


@end
