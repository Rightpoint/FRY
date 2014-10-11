//
//  PointInTime.h
//  FRY
//
//  Created by Brian King on 10/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

@import UIKit;

/**
 * Simple model object associating a point in time.
 */
@interface FRYPointInTime : NSObject

- (id)initWithLocation:(CGPoint)location offset:(NSTimeInterval)offset;

@property (assign, nonatomic) CGPoint location;
@property (assign, nonatomic) NSTimeInterval offset;

@end
