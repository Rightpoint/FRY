//
//  FRYQueryResult.m
//  FRY
//
//  Created by Brian King on 10/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYLookupResult.h"

@interface FRYLookupResult()

@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) CGRect frame;

@end

@implementation FRYLookupResult

- (instancetype)initWithView:(UIView *)view frame:(CGRect)frame
{
    self = [super init];
    if ( self ) {
        _view = view;
        _frame = frame;
    }
    return self;
}

- (NSUInteger)hash
{
    return [self.view hash] ^ [[NSValue valueWithCGRect:self.frame] hash];
}

- (BOOL)isEqual:(FRYLookupResult *)otherResult
{
    if ( [otherResult isKindOfClass:[FRYLookupResult class]] == NO ) {
        return NO;
    }
    BOOL equal = ([self.view isEqual:otherResult.view] &&
                  CGRectEqualToRect(self.frame, otherResult.frame));
    return equal;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p view=%@, frame=%@", self.class, self, self.view, NSStringFromCGRect(self.frame)];
}
@end
