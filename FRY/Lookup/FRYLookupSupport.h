//
//  FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"

@protocol FRYLookupSupport <NSObject>

+ (id<FRYLookup>)fry_query;

@end
