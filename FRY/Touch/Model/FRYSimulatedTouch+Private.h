//
//  FRYSimulatedTouch+Private.h
//  FRY
//
//  Created by Brian King on 10/10/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "FRYSimulatedTouch.h"
#import "FRYPointInTime.h"

@interface FRYSimulatedTouch()

@property (strong, nonatomic, readonly) NSMutableArray *pointsInTime;

@property (assign, nonatomic) NSTimeInterval startingOffset;

@end
