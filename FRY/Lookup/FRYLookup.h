//
//  IDLookup.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FRYLookup <NSObject>

- (NSArray *)lookForMatchingObjectsStartingFrom:(NSObject *)object;

@end
