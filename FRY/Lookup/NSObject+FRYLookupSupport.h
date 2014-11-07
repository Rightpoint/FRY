//
//  NSObject+FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRYDefines.h"

@interface NSObject(FRYLookupSupport)

- (void)fry_farthestDescendentMatching:(NSPredicate *)predicate usingBlock:(FRYFirstMatchBlock)block;
- (void)fry_enumerateAllViewsMatching:(NSPredicate *)predicate usingBlock:(FRYFirstMatchBlock)block;

@end
