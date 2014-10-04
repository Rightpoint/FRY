//
//  IDKVTreeLookup.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYLookup.h"

@interface FRYKVTreeLookup : NSObject <FRYLookup>

- (id)initWithChildKeyPaths:(NSArray *)childKeyPaths predicate:(NSPredicate *)predicate;

@end
