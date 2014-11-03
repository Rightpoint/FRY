//
//  FRYLookupSupport.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRYLookupResult;

@protocol FRYLookupSupport <NSObject>

+ (NSSet *)fry_childKeyPaths;

- (FRYLookupResult *)fry_lookupResult;

@end
