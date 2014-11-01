//
//  FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"
#import "FRYDefines.h"

@protocol FRYLookupSupport <NSObject>

+ (id<FRYLookup>)fry_lookup;

- (void)fry_enumerateDepthFirstViewMatching:(NSDictionary *)variables usingBlock:(FRYFirstMatchBlock)block;
- (void)fry_enumerateAllViewsMatching:(NSDictionary *)variables usingBlock:(FRYFirstMatchBlock)block;

@end
