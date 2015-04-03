//
//  NSObject+FRYLookup.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"

/**
 *  Since all of NSObject "supports" accessibility, FRYLookup is supported
 *  by every object too. It may not actually work on all objects.
 */
@interface NSObject(FRYLookup) <FRYLookup>
@end

@interface NSObject(FRYLookupDebug)

+ (void)fry_enableLookupDebugForObjects:(NSArray *)objects;

@end

@interface UIView(FRYLookup)

+ (void)fry_setLookupAccessibilityChildren:(BOOL)lookupAccessibilityChildren;

@end