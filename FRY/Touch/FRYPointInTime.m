//
//  PointInTime.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYPointInTime.h"

@implementation FRYPointInTime

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p location=%@, offset=%f", self.class, self, NSStringFromCGPoint(self.location), self.offset];
}

@end
