//
//  IDKVTreeLookup.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRYQuery.h"

@interface FRYKeyValueTreeQuery : NSObject <FRYQuery>

- (id)initWithChildKeyPaths:(NSArray *)childKeyPaths predicate:(NSPredicate *)predicate;

@end
