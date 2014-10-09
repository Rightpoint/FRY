//
//  FRYQueryResult.m
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYLookupResult.h"

@implementation FRYLookupResult

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p view=%@, frame=%@", self.class, self, self.view, NSStringFromCGRect(self.frame)];
}
@end
