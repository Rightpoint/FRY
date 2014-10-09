//
//  FRYInteraction.m
//  FRY
//
//  Created by Brian King on 10/9/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYInteraction.h"

@implementation FRYInteraction

+ (FRYInteraction *)interactionWithTargetWindow:(FRYTargetWindow)targetWindow
                                lookupVariables:(NSDictionary *)lookupVariables
                                     foundBlock:(FRYInteractionBlock)foundBlock
{
    FRYInteraction *interaction = [[FRYInteraction alloc] init];
    interaction.targetWindow = targetWindow;
    interaction.lookupVariables = lookupVariables;
    interaction.foundBlock = foundBlock;
    return interaction;
}

@end
