//
//  FRYInteraction.h
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYDefines.h"

@class FRYLookup;
@class FRYSimulatedTouch;


@interface FRYInteraction : NSObject

+ (FRYInteraction *)interactionWithTargetWindow:(FRYTargetWindow)targetWindow
                                lookupVariables:(NSDictionary *)lookupVariables
                                     foundBlock:(FRYInteractionBlock)foundBlock;

@property (assign, nonatomic, readonly) FRYTargetWindow targetWindow;
@property (strong, nonatomic, readonly) NSDictionary *lookupVariables;
@property (copy, nonatomic, readonly) FRYInteractionBlock foundBlock;
//@property (strong, nonatomic) FRYInteraction *dependentInteraction;

@end
