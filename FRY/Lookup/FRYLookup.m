//
//  FRYQuery.m
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYLookup.h"
#import "FRYLookupResult.h"
#import "FRYLookupSupport.h"



@implementation FRYLookup

- (id)init
{
    self = [super init];
    if ( self ) {
        self.matchPredicate = [NSPredicate predicateWithValue:YES];
        self.descendPredicate = [NSPredicate predicateWithValue:YES];
    }
    return self;
}

- (NSArray *)lookupChildrenOfObject:(NSObject *)object matchingVariables:(NSDictionary *)variables;
{
    NSMutableArray *results = [NSMutableArray array];
    
    if ( [self.matchPredicate evaluateWithObject:object substitutionVariables:variables] ) {
        FRYLookupResult *match = self.matchTransform(object);
        [results addObject:match];
    }
    for ( NSString *childKeyPath in self.childKeyPaths ) {
        NSArray *children = [object valueForKeyPath:childKeyPath];
        for ( NSObject *child in children) {
            if ( [self.descendPredicate evaluateWithObject:child  substitutionVariables:variables] ) {
                id<FRYLookup> lookup = [child.class fry_query];
                NSArray *subResults = [lookup lookupChildrenOfObject:object matchingVariables:variables];
                [results addObjectsFromArray:subResults];
            }
        }
    }
    return results;
}

@end
