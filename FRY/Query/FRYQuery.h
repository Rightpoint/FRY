//
//  IDLookup.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FRYQueryResult)(NSArray *results);
typedef void(^FRYSingularQueryResult)(id view);


@protocol FRYQuery <NSObject>

- (NSArray *)lookForMatchingObjectsStartingFrom:(NSObject *)object;

@end
