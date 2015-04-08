//
//  PointInTime.m
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYPointInTime.h"

@implementation FRYPointInTime

- (id)initWithLocation:(CGPoint)location offset:(NSTimeInterval)offset
{
    self = [super init];
    if ( self ) {
        _location = location;
        _offset = offset;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p location=%@, offset=%0.1f>", self.class, self, NSStringFromCGPoint(self.location), self.offset];
}

- (NSArray *)arrayRepresentation
{
    return @[@(self.location.x), @(self.location.y), @(self.offset)];
}

@end
