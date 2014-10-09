//
//  FRYQuery.h
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRYLookupResult;

@protocol FRYLookup <NSObject>

- (NSArray *)lookupChildrenOfObject:(NSObject *)object matchingVariables:(NSDictionary *)variables;

@end

typedef FRYLookupResult *(^FRYLookupResultTransform)(id object);

@interface FRYLookup : NSObject <FRYLookup>

@property (strong, nonatomic) NSPredicate *matchPredicate;
@property (strong, nonatomic) NSPredicate *descendPredicate;
@property (copy, nonatomic) NSArray *childKeyPaths;
@property (copy, nonatomic) FRYLookupResultTransform matchTransform;

@end


