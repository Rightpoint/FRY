//
//  UIView+FRY.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FRY)

- (BOOL)fry_hasAnimationToWaitFor;

- (NSDictionary *)fry_matchingLookupVariables;

@end
