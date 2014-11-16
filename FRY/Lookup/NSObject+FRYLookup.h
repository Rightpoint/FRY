//
//  NSObject+FRYLookup.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"

@interface UIApplication(FRYLookup) <FRYLookup>
@end
@interface UIView(FRYLookup) <FRYLookup>
@end
@interface UIAccessibilityElement(FRYLookup) <FRYLookup>
@end


@interface NSObject(FRYLookupDebug)

+ (void)fry_enableLookupDebugForObjects:(NSArray *)objects;

@end
